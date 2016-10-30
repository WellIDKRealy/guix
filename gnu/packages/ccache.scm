;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2014, 2015, 2016 Eric Bavier <bavier@member.fsf.org>
;;; Copyright © 2016 Efraim Flashner <efraim@flashner.co.il>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (gnu packages ccache)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:select (gpl3+))
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages compression))

(define-public ccache
  (package
    (name "ccache")
    (version "3.3.3")
    (source
     (origin
      (method url-fetch)
      (uri (string-append "https://www.samba.org/ftp/ccache/ccache-"
                          version ".tar.xz"))
      (sha256
       (base32
        "1v04ky2mhvx8gnqfbs9x2vvf4i9mzph4fwdg72s9xyhwv92sf0iv"))))
    (build-system gnu-build-system)
    (native-inputs `(("perl" ,perl)     ;for test.sh
                     ("which" ,(@ (gnu packages base) which))))
    (inputs `(("zlib" ,zlib)))
    (arguments
     '(#:phases (modify-phases %standard-phases
                 (add-before 'check 'setup-tests
                   (lambda _
                     (substitute* '("test/test_hashutil.c" "test.sh")
                       (("#!/bin/sh") (string-append "#!" (which "sh")))
                       (("which") (which "which")))
                     #t)))))
    (home-page "https://ccache.samba.org/")
    (synopsis "Compiler cache")
    (description
     "Ccache is a compiler cache.  It speeds up recompilation by caching
previous compilations and detecting when the same compilation is being done
again.  Supported languages are C, C++, Objective-C, Objective-C++, and
Fortran 77.")
    (license gpl3+)))
