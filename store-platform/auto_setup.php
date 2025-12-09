<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

use Webkul\User\Models\Admin;
use Webkul\User\Models\Role;
use Webkul\Core\Models\Locale;
use Webkul\Core\Models\Currency;
use Webkul\Core\Models\Channel;
use Webkul\Inventory\Models\InventorySource;
use Webkul\Customer\Models\CustomerGroup;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

echo "Starting Bagisto Auto-Setup...\n\n";

// Step 1: Create/Update Admin User
echo "[1/7] Creating admin user...\n";
$role = Role::firstOrCreate(
    ['name' => 'Administrator'],
    [
        'name' => 'Administrator',
        'description' => 'Administrator role',
        'permission_type' => 'all',
    ]
);

$admin = Admin::updateOrCreate(
    ['email' => 'admin@example.com'],
    [
        'name' => 'Admin User',
        'password' => Hash::make('admin123'),
        'status' => 1,
        'role_id' => $role->id,
    ]
);
echo "   ✓ Admin created: {$admin->email}\n\n";

// Step 2: Setup Default Locale
echo "[2/7] Setting up locale...\n";
$locale = Locale::firstOrCreate(
    ['code' => 'en'],
    [
        'code' => 'en',
        'name' => 'English',
        'direction' => 'ltr',
    ]
);
echo "   ✓ Locale configured: {$locale->name}\n\n";

// Step 3: Setup Default Currency
echo "[3/7] Setting up currency...\n";
$currency = Currency::firstOrCreate(
    ['code' => 'USD'],
    [
        'code' => 'USD',
        'name' => 'US Dollar',
        'symbol' => '$',
    ]
);
echo "   ✓ Currency configured: {$currency->name}\n\n";

// Step 4: Setup Default Inventory Source
echo "[4/7] Setting up inventory source...\n";
$inventorySource = InventorySource::firstOrCreate(
    ['code' => 'default'],
    [
        'code' => 'default',
        'name' => 'Default',
        'description' => 'Default inventory source',
        'contact_name' => 'Admin User',
        'contact_email' => 'admin@example.com',
        'contact_number' => '1234567890',
        'status' => 1,
        'country' => 'US',
        'state' => 'NY',
        'city' => 'New York',
        'street' => '123 Main St',
        'postcode' => '10001',
    ]
);
echo "   ✓ Inventory source configured: {$inventorySource->name}\n\n";

// Step 5: Setup Customer Group
echo "[5/7] Setting up customer group...\n";
$customerGroup = CustomerGroup::firstOrCreate(
    ['code' => 'guest'],
    [
        'code' => 'guest',
        'name' => 'Guest',
        'is_user_defined' => 0,
    ]
);
echo "   ✓ Customer group configured: {$customerGroup->name}\n\n";

// Step 6: Setup Default Channel
echo "[6/7] Setting up default channel...\n";
$channel = Channel::firstOrCreate(
    ['code' => 'default'],
    [
        'code' => 'default',
        'name' => 'Default',
        'description' => 'Default channel',
        'hostname' => 'http://localhost:4588',
        'theme' => 'default',
        'home_page_content' => '<h1>Welcome to our store!</h1>',
        'footer_content' => '<p>&copy; 2025 Dropshipping Empire</p>',
        'default_locale_id' => $locale->id,
        'base_currency_id' => $currency->id,
        'root_category_id' => 1,
    ]
);

// Associate locales and currencies with channel
if ($channel) {
    DB::table('channel_locales')->updateOrInsert(
        ['channel_id' => $channel->id, 'locale_id' => $locale->id],
        ['channel_id' => $channel->id, 'locale_id' => $locale->id]
    );
    
    DB::table('channel_currencies')->updateOrInsert(
        ['channel_id' => $channel->id, 'currency_id' => $currency->id],
        ['channel_id' => $channel->id, 'currency_id' => $currency->id]
    );
    
    DB::table('channel_inventory_sources')->updateOrInsert(
        ['channel_id' => $channel->id, 'inventory_source_id' => $inventorySource->id],
        ['channel_id' => $channel->id, 'inventory_source_id' => $inventorySource->id]
    );
}
echo "   ✓ Channel configured: {$channel->name}\n\n";

// Step 7: Update Core Config
echo "[7/7] Updating core configuration...\n";
$configs = [
    'general.general.locale_settings.locale' => 'en',
    'general.general.locale_settings.weight_unit' => 'lbs',
    'general.content.footer.footer_content' => '<p>&copy; 2025 Dropshipping Empire. All rights reserved.</p>',
    'general.design.admin_logo.logo_image' => '',
    'general.design.admin_logo.favicon' => '',
];

foreach ($configs as $key => $value) {
    DB::table('core_config')->updateOrInsert(
        ['code' => $key, 'channel_code' => 'default'],
        [
            'code' => $key,
            'value' => $value,
            'channel_code' => 'default',
            'locale_code' => 'en',
        ]
    );
}
echo "   ✓ Core configuration updated\n\n";

// Clear caches
echo "Clearing caches...\n";
try {
    \Illuminate\Support\Facades\Artisan::call('config:clear');
    \Illuminate\Support\Facades\Artisan::call('cache:clear');
    \Illuminate\Support\Facades\Artisan::call('view:clear');
    echo "   ✓ Caches cleared\n\n";
} catch (\Exception $e) {
    echo "   ! Cache clearing skipped\n\n";
}

echo "╔════════════════════════════════════════════════════════════════╗\n";
echo "║              BAGISTO SETUP COMPLETE! ✅                        ║\n";
echo "╚════════════════════════════════════════════════════════════════╝\n\n";
echo "🎉 Your store is now ready!\n\n";
echo "Admin Panel: http://localhost:4588/admin\n";
echo "Storefront:  http://localhost:4588\n\n";
echo "Login Credentials:\n";
echo "  Email:    admin@example.com\n";
echo "  Password: admin123\n\n";
echo "You can now login and start using your store!\n";
