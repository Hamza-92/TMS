<?php

namespace App\Exceptions;

use RuntimeException;

class CustomerLimitReached extends RuntimeException
{
    public function __construct(public readonly int $limit)
    {
        parent::__construct('The subscription customer limit has been reached.');
    }
}
