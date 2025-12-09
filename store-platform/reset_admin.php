<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

use Webkul\User\Models\Admin;
use Webkul\User\Models\Role;
use Illuminate\Support\Facades\Hash;

$admin = Admin::where('email', 'admin@example.com')->first();

if ($admin) {
    $admin->password = Hash::make('admin123');
    $admin->status = 1;
    $admin->save();
    echo "✓ Admin password reset\n";
} else {
    $role = Role::first();
    $admin = Admin::create([
        'name' => 'Admin User',
        'email' => 'admin@example.com',
        'password' => Hash::make('admin123'),
        'status' => 1,
        'role_id' => $role ? $role->id : 1,
    ]);
    echo "✓ Admin created\n";
}

echo "\n========================================\n";
echo "ADMIN LOGIN CREDENTIALS\n";
echo "========================================\n";
echo "URL: http://localhost:4588/admin\n";
echo "Email: admin@example.com\n";
echo "Password: admin123\n";
echo "========================================\n";
