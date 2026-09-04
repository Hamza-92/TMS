<?php

namespace App\Http\Requests\Admin;

use App\Enums\BillingPeriod;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StorePlanRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /** @return array<string, array<int, mixed>> */
    public function rules(): array
    {
        return $this->planRules();
    }

    /** @return array<string, array<int, mixed>> */
    protected function planRules(): array
    {
        return [
            'name' => ['required', 'string', 'max:100'],
            'description' => ['nullable', 'string', 'max:1000'],
            'billing_period' => [
                'required',
                Rule::in([
                    BillingPeriod::Monthly->value,
                    BillingPeriod::Quarterly->value,
                    BillingPeriod::Yearly->value,
                ]),
            ],
            'price' => ['required', 'numeric', 'min:1', 'max:9999999999.99', 'decimal:0,2'],
            'is_active' => ['nullable', 'boolean'],
            'features' => ['nullable', 'array'],
            'features.cloud_backup' => ['nullable', 'boolean'],
            'features.reports' => ['nullable', 'boolean'],
            'features.staff_accounts' => ['nullable', 'boolean'],
            'limits' => ['required', 'array'],
            'limits.staff' => ['required', 'integer', 'min:1', 'max:1000'],
            'limits.devices' => ['required', 'integer', 'min:1', 'max:1000'],
            'limits.customers' => ['required', 'integer', 'min:1', 'max:10000000'],
        ];
    }

    /** @return array<string, string> */
    public function messages(): array
    {
        return [
            'price.min' => 'Enter a paid-plan price of at least PKR 1.',
            'price.decimal' => 'The price may contain no more than two decimal places.',
            'limits.staff.required' => 'Enter the number of staff accounts included.',
            'limits.devices.required' => 'Enter the number of devices included.',
            'limits.customers.required' => 'Enter the customer limit included.',
        ];
    }
}
