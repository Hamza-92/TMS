<?php

namespace App\Exceptions;

use Illuminate\Database\Eloquent\Model;
use RuntimeException;

class MeasurementVersionConflict extends RuntimeException
{
    public function __construct(
        public readonly Model $record,
        public readonly string $entityType,
    ) {
        parent::__construct('This record was changed on another device. Review the latest version and try again.');
    }
}
