"""
Dropshipping Research Bot - Amazon & BestBuy Scraper
Performs product search, price filtering, and Gemini-powered sentiment analysis
"""

import csv
import os
import json
import time
from playwright.sync_api import sync_playwright
import google.generativeai as genai

# Configuration
OUTPUT_DIR = "/app/data_shared"
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "winners.csv")
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY", "")

# Initialize Gemini
if GEMINI_API_KEY:
    genai.configure(api_key=GEMINI_API_KEY)
    model = genai.GenerativeModel('gemini-2.0-flash-exp')
else:
    model = None
    print("⚠️ Warning: GEMINI_API_KEY not found. Sentiment analysis will use basic logic.")

def analyze_sentiment_with_gemini(reviews_text):
    """Use Gemini to analyze sentiment of product reviews"""
    if not model or not reviews_text:
        return 0.5  # Neutral score if no AI or no reviews
    
    try:
        prompt = f"""Analyze these customer reviews and return ONLY a sentiment score from 0.0 to 1.0:
        - 0.0 = Very negative
        - 0.5 = Neutral
        - 1.0 = Very positive
        
        Reviews:
        {reviews_text[:3000]}  # Limit to 3000 chars
        
        Return ONLY the numeric score, nothing else."""
        
        response = model.generate_content(prompt)
        score = float(response.text.strip())
        return max(0.0, min(1.0, score))  # Clamp between 0 and 1
    except Exception as e:
        print(f"Gemini sentiment analysis error: {e}")
        return 0.5

def scrape_amazon(keyword, max_products=5):
    """Scrape Amazon for products"""
    print(f"🔍 Searching Amazon for: {keyword}")
    products = []
    
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        
        try:
            # Search Amazon
            search_url = f'https://www.amazon.com/s?k={keyword.replace(" ", "+")}'
            page.goto(search_url, timeout=30000)
            page.wait_for_timeout(3000)
            
            # Extract product cards - Multiple selector strategies
            product_cards = page.query_selector_all('[data-component-type="s-search-result"]')
            
            for card in product_cards[:max_products]:
                try:
                    # Product name - Try multiple selectors
                    name = "Unknown"
                    name_selectors = [
                        'h2 a span',
                        'h2.s-line-clamp-2 span',
                        'h2 span.a-text-normal',
                        '.s-title-instructions-style span',
                        '[data-cy="title-recipe"] span',
                        'h2 a'
                    ]
                    for selector in name_selectors:
                        name_elem = card.query_selector(selector)
                        if name_elem:
                            name = name_elem.inner_text().strip()
                            if name and name != "Unknown":
                                break
                    
                    # Price - Try multiple selectors
                    price = "0"
                    price_selectors = [
                        '.a-price .a-offscreen',
                        'span.a-price-whole',
                        '.a-price-fraction',
                        'span[data-a-color="price"] span.a-offscreen'
                    ]
                    for selector in price_selectors:
                        price_elem = card.query_selector(selector)
                        if price_elem:
                            price_text = price_elem.inner_text().replace('$', '').strip()
                            if price_text and price_text != "0":
                                price = price_text
                                break
                    
                    # Rating - Try multiple selectors
                    rating = "0"
                    rating_selectors = [
                        '.a-icon-star-small span.a-icon-alt',
                        'span[aria-label*="out of 5 stars"]',
                        '.a-star-small span'
                    ]
                    for selector in rating_selectors:
                        rating_elem = card.query_selector(selector)
                        if rating_elem:
                            rating_text = rating_elem.get_attribute('innerHTML') or rating_elem.inner_text()
                            if rating_text:
                                # Extract numeric rating
                                import re
                                match = re.search(r'(\d+\.?\d*)', rating_text)
                                if match:
                                    rating = match.group(1)
                                    break
                    
                    # Reviews count
                    reviews_elem = card.query_selector('span[aria-label*="stars"]')
                    reviews_count = 0
                    if reviews_elem:
                        aria_label = reviews_elem.get_attribute('aria-label')
                        try:
                            reviews_count = int(''.join(filter(str.isdigit, aria_label.split(',')[-1])))
                        except:
                            pass
                    
                    # Get product link for sentiment analysis
                    link_elem = card.query_selector('h2 a')
                    product_link = f"https://www.amazon.com{link_elem.get_attribute('href')}" if link_elem else ""
                    
                    products.append({
                        'name': name,
                        'price': price,
                        'rating': rating,
                        'reviews_count': reviews_count,
                        'source': 'Amazon',
                        'link': product_link
                    })
                    
                except Exception as e:
                    print(f"Error parsing Amazon product: {e}")
                    continue
            
        except Exception as e:
            print(f"Error scraping Amazon: {e}")
        finally:
            browser.close()
    
    return products

def scrape_bestbuy(keyword, max_products=5):
    """Scrape BestBuy for products"""
    print(f"🔍 Searching BestBuy for: {keyword}")
    products = []
    
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        
        try:
            # Search BestBuy
            search_url = f'https://www.bestbuy.com/site/searchpage.jsp?st={keyword.replace(" ", "+")}'
            page.goto(search_url, timeout=30000)
            page.wait_for_timeout(3000)
            
            # Extract product items - Multiple selector strategies
            product_items = page.query_selector_all('.sku-item, li.sku-item')
            
            for item in product_items[:max_products]:
                try:
                    # Product name - Try multiple selectors
                    name = "Unknown"
                    name_selectors = [
                        '.sku-title a',
                        'h4.sku-title a',
                        '.sku-header a',
                        'a.sku-title'
                    ]
                    for selector in name_selectors:
                        name_elem = item.query_selector(selector)
                        if name_elem:
                            name = name_elem.inner_text().strip()
                            if name and name != "Unknown":
                                break
                    
                    # Price - Try multiple selectors
                    price = "0"
                    price_selectors = [
                        '.priceView-customer-price span',
                        '.priceView-hero-price span',
                        'span[aria-hidden="true"]',
                        '.priceView-customer-price'
                    ]
                    for selector in price_selectors:
                        price_elem = item.query_selector(selector)
                        if price_elem:
                            price_text = price_elem.inner_text().replace('$', '').replace(',', '').strip()
                            if price_text and price_text != "0":
                                price = price_text
                                break
                    
                    # Rating - Try multiple selectors
                    rating = "0"
                    rating_selectors = [
                        '.c-ratings-reviews-v4 .c-review-average',
                        '.rating-stars .rating-value',
                        '[aria-label*="Rating"]'
                    ]
                    for selector in rating_selectors:
                        rating_elem = item.query_selector(selector)
                        if rating_elem:
                            rating_text = rating_elem.inner_text().strip() or rating_elem.get_attribute('aria-label')
                            if rating_text:
                                import re
                                match = re.search(r'(\d+\.?\d*)', rating_text)
                                if match:
                                    rating = match.group(1)
                                    break
                    
                    # Reviews count
                    reviews_elem = item.query_selector('.c-ratings-reviews-v4 .c-reviews-v4')
                    reviews_count = 0
                    if reviews_elem:
                        try:
                            reviews_count = int(''.join(filter(str.isdigit, reviews_elem.inner_text())))
                        except:
                            pass
                    
                    # Get product link
                    link_elem = item.query_selector('.sku-title a')
                    product_link = f"https://www.bestbuy.com{link_elem.get_attribute('href')}" if link_elem else ""
                    
                    products.append({
                        'name': name,
                        'price': price,
                        'rating': rating,
                        'reviews_count': reviews_count,
                        'source': 'BestBuy',
                        'link': product_link
                    })
                    
                except Exception as e:
                    print(f"Error parsing BestBuy product: {e}")
                    continue
            
        except Exception as e:
            print(f"Error scraping BestBuy: {e}")
        finally:
            browser.close()
    
    return products

def get_product_reviews(product_link, source):
    """Scrape reviews from product page"""
    reviews_text = ""
    
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        
        try:
            page.goto(product_link, timeout=30000)
            page.wait_for_timeout(2000)
            
            if source == "Amazon":
                # Get first 5 reviews
                review_elems = page.query_selector_all('.review-text-content span')[:5]
                reviews_text = ' '.join([elem.inner_text() for elem in review_elems])
            
            elif source == "BestBuy":
                # Get first 5 reviews
                review_elems = page.query_selector_all('.review-text')[:5]
                reviews_text = ' '.join([elem.inner_text() for elem in review_elems])
            
        except Exception as e:
            print(f"Error getting reviews from {source}: {e}")
        finally:
            browser.close()
    
    return reviews_text

def main():
    """Main scraping and analysis workflow"""
    # Get search keyword from environment or use default
    keyword = os.getenv("SEARCH_KEYWORD", "wireless earbuds")
    print(f"\n{'='*60}")
    print(f"🤖 DROPSHIPPING RESEARCH BOT - STARTING")
    print(f"{'='*60}\n")
    print(f"🎯 Search Keyword: {keyword}\n")
    
    # Scrape both platforms
    all_products = []
    all_products.extend(scrape_amazon(keyword, max_products=5))
    time.sleep(2)  # Be nice to servers
    all_products.extend(scrape_bestbuy(keyword, max_products=5))
    
    if not all_products:
        print("❌ No products found!")
        return
    
    print(f"\n✓ Found {len(all_products)} products")
    
    # Sort by price (ascending) and get top candidates
    # Clean price strings by removing currency symbols and converting to float
    def clean_price(price_str):
        if not price_str or price_str == '0':
            return 9999.0
        # Remove currency symbols, spaces, and non-numeric characters except decimal point
        import re
        cleaned = re.sub(r'[^\d.]', '', price_str)
        try:
            return float(cleaned) if cleaned else 9999.0
        except:
            return 9999.0
    
    all_products.sort(key=lambda x: clean_price(x['price']))
    top_candidates = all_products[:5]
    
    print(f"\n🔬 Analyzing sentiment for top 5 lowest-priced products...\n")
    
    # Perform sentiment analysis
    results = []
    for product in top_candidates:
        print(f"📊 Analyzing: {product['name'][:50]}...")
        
        # Get reviews if we have a link
        reviews_text = ""
        if product['link']:
            reviews_text = get_product_reviews(product['link'], product['source'])
        
        # Calculate sentiment score
        sentiment_score = analyze_sentiment_with_gemini(reviews_text)
        
        results.append({
            'Product Name': product['name'],
            'Price': f"${product['price']}",
            'Rating': product['rating'],
            'Reviews Count': product['reviews_count'],
            'Sentiment Score': f"{sentiment_score:.2f}",
            'Source': product['source'],
            'Link': product['link']
        })
        
        print(f"   Sentiment Score: {sentiment_score:.2f}")
    
    # Sort by sentiment score (highest first)
    results.sort(key=lambda x: float(x['Sentiment Score']), reverse=True)
    
    # Save to CSV
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    with open(OUTPUT_FILE, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=['Product Name', 'Price', 'Rating', 'Reviews Count', 'Sentiment Score', 'Source', 'Link'])
        writer.writeheader()
        writer.writerows(results)
    
    print(f"\n{'='*60}")
    print(f"✅ COMPLETE - Winners saved to: {OUTPUT_FILE}")
    print(f"{'='*60}")
    print(f"\n🏆 TOP WINNER:")
    print(f"   {results[0]['Product Name'][:60]}")
    print(f"   Price: {results[0]['Price']} | Sentiment: {results[0]['Sentiment Score']} | Source: {results[0]['Source']}\n")

if __name__ == "__main__":
    main()
