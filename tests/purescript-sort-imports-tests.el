;;; purescript-sort-imports-tests.el --- Unit tests for purescript-sort-imports -*- lexical-binding: t -*-

;; Copyright (c) 2014 Chris Done. All rights reserved.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Code:

(require 'ert)
(require 'purescript-sort-imports)

(ert-deftest empty-buffer ()
  (with-temp-buffer
    (purescript-sort-imports)
    t))

(ert-deftest single-line ()
  (with-temp-buffer
    (insert "import A\n")
    (goto-char (point-min))
    (purescript-sort-imports)
    (should (string= (buffer-string)
                     "import A\n"))))

(ert-deftest two-idem ()
  (with-temp-buffer
    (insert "import A
import B
")
    (goto-char (point-min))
    (purescript-sort-imports)
    (should (string= (buffer-string)
                     "import A
import B
")))
  (with-temp-buffer
    (insert "import A (A, B, C)
import B
")
    (goto-char (point-min))
    (purescript-sort-imports)
    (should (string= (buffer-string)
                     "import A (A, B, C)
import B
")))
  (with-temp-buffer
    (insert "import A (mtl)
import B
")
    (goto-char (point-min))
    (purescript-sort-imports)
    (should (string= (buffer-string)
                     "import A (mtl)
import B
"))))

(ert-deftest two-rev ()
  (with-temp-buffer
    (insert "import B
import A
")
    (goto-char (point-min))
    (purescript-sort-imports)
    (should (string= (buffer-string)
                     "import A
import B
"))))

(ert-deftest file-structure ()
  (with-temp-buffer
    (insert "module A where
import B
import A
")
    ;; test at line 2
    (goto-char (point-min))
    (forward-line 1)
    (purescript-sort-imports)
    (should (string= (buffer-string)
                     "module A where
import A
import B
")))
  (with-temp-buffer
    (insert "module C where

import B
import A
")
    ;; test at line 3
    (goto-char (point-min))
    (forward-line 2)
    (purescript-sort-imports)
    (should (string= (buffer-string)
                     "module C where

import A
import B
"))))

(ert-deftest bos-270 ()
  (with-temp-buffer
    (insert "import Data.Aeson.Encode (encode)
import Data.Aeson.Types
import Data.Aeson.Parser.Internal (decodeWith, decodeStrictWith,
                                   eitherDecodeWith, eitherDecodeStrictWith,
                                   jsonEOF, json, jsonEOF', json')
import Data.ByteString as B
import Data.ByteString.Lazy as L
")
    (goto-char (point-min))
    (purescript-sort-imports)
    (should (string= (buffer-string)
                     "import Data.Aeson.Encode (encode)
import Data.Aeson.Parser.Internal (decodeWith, decodeStrictWith,
                                   eitherDecodeWith, eitherDecodeStrictWith,
                                   jsonEOF, json, jsonEOF', json')
import Data.Aeson.Types
import Data.ByteString as B
import Data.ByteString.Lazy as L
"))))

(provide 'purescript-sort-imports-tests)
