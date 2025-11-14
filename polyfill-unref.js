// Ensure process.stdin.unref exists in non-TTY runs
/* eslint-disable no-undef */
'use strict';

if (typeof process !== 'undefined' &&
    process.stdin &&
    typeof process.stdin.unref !== 'function') {
  process.stdin.unref = function () {};
}
