<?php

namespace App\Exceptions;

use RuntimeException;

class MeasurementOperationConflict extends RuntimeException
{
    public function __construct()
    {
        parent::__construct('This operation identifier was already used for different measurement data.');
    }
}
