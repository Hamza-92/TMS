<?php

namespace App\Exceptions;

use RuntimeException;

class CustomerOperationConflict extends RuntimeException
{
    public function __construct()
    {
        parent::__construct('The operation identifier was already used for a different change.');
    }
}
