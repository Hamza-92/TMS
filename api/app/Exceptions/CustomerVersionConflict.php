<?php

namespace App\Exceptions;

use App\Models\Customer;
use RuntimeException;

class CustomerVersionConflict extends RuntimeException
{
    public function __construct(public readonly Customer $customer)
    {
        parent::__construct('The customer was changed on another device.');
    }
}
