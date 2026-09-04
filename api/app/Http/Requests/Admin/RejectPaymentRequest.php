<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class RejectPaymentRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /** @return array<string, array<int, mixed>> */
    public function rules(): array
    {
        return [
            'rejection_reason' => ['required', 'string', 'min:10', 'max:500'],
            'admin_notes' => ['nullable', 'string', 'max:1000'],
        ];
    }

    /** @return array<string, string> */
    public function messages(): array
    {
        return [
            'rejection_reason.required' => 'Explain why this payment cannot be verified.',
            'rejection_reason.min' => 'The rejection reason must be at least 10 characters.',
            'rejection_reason.max' => 'The rejection reason may not exceed 500 characters.',
        ];
    }
}
