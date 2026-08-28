<?php

namespace Database\Seeders;

use App\Models\Plan;
use Illuminate\Database\Seeder;

class PlanSeeder extends Seeder
{
    public function run(): void
    {
        Plan::query()->updateOrCreate(
            ['code' => 'demo'],
            [
                'name' => 'Demo',
                'description' => 'Automatic evaluation plan for newly verified businesses.',
                'billing_period' => 'custom',
                'price' => 0,
                'currency_code' => 'PKR',
                'trial_days' => 14,
                'features' => [
                    'cloud_backup' => true,
                    'reports' => true,
                    'staff_accounts' => false,
                ],
                'limits' => [
                    'staff' => 1,
                    'devices' => 1,
                    'customers' => 250,
                ],
                'is_active' => true,
                'sort_order' => 0,
            ],
        );
    }
}
