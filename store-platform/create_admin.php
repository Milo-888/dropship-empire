<?php

use Webkul\User\Models\Admin;
use Webkul\User\Models\Role;
use Illuminate\Support\Facades\Hash;

// Check if admin exists
$existingAdmin = Admin::where('email', 'admin@example.com')->first();

if ($existingAdmin) {
    // Update password
    $existingAdmin->password = Hash::make('admin123');
    $existingAdmin->status = 1;
    $existingAdmin->save();
    echo "✓ Admin password reset for: " . $existingAdmin->email . "\n";
} else {
    // Create new admin
    $role = Role::first();
    
    $admin = Admin::create([
        'name' => 'Admin User',
        'email' => 'admin@example.com',
        'password' => Hash::make('admin123'),
        'status' => 1,
        'role_id' => $role ? $role->id : 1,
    ]);
    
    echo "✓ Admin created: " . $admin->email . "\n";
}

echo "\n=================================\n";
echo "Admin Login Credentials:\n";
echo "=================================\n";
echo "Email: admin@example.com\n";
echo "Password: admin123\n";
echo "URL: http://localhost:4588/admin\n";
echo "=================================\n";
