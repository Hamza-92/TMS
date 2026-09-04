<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class SuspendBusinessRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /** @return array<string, array<int, string>> */
    public function rules(): array
    {
        return [
            'reason' => ['required', 'string', 'min:10', 'max:500'],
        ];
    }

    /** @return array<string, string> */
    public function messages(): array
    {
        return [
            'reason.required' => 'Enter a clear reason for suspending this business.',
            'reason.min' => 'The suspension reason must be at least 10 characters.',
            'reason.max' => 'The suspension reason cannot exceed 500 characters.',
        ];
    }
}
