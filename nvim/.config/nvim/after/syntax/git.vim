syn match gitKeyword "^gpg:"  contained containedin=gitHead skipwhite contains=@NoSpell

syn match gitSignatureGood "^Good \"git\" signature for .*$" contained containedin=gitHead skipwhite contains=@NoSpell
syn match gitSignatureUntrusted "^Good \"git\" signature with .*$" contained containedin=gitHead skipwhite contains=@NoSpell
syn match gitSignatureUntrusted "^No principal matched\.$" contained containedin=gitHead skipwhite contains=@NoSpell
syn match gitSignatureUnknown "^Could not verify signature\.$" contained containedin=gitHead skipwhite contains=@NoSpell
syn match gitSignatureBad "^Signature verification failed: .*$" contained containedin=gitHead skipwhite contains=@NoSpell

syn match gitSignaturePrincipal "!\?[a-zA-Z0-9.*?_+-]\+@[a-zA-Z0-9.*?-]\+" contained containedin=gitSignatureGood skipwhite contains=@NoSpell
syn match gitSignatureKeyId "SHA256:.*$" contained containedin=gitSignatureGood,gitSignatureUntrusted skipwhite contains=@NoSpell

"This is not an appropriate link, but the default Directory highlights are very
"close to how Git displays a good signature, so just do it this way for now.
hi def link gitSignatureGood Directory
hi def link gitSignatureUntrusted DiagnosticHint
hi def link gitSignatureUnknown DiagnosticWarn
hi def link gitSignatureBad DiagnosticError

hi def link gitSignaturePrincipal gitEmail
hi def link gitSignatureKeyId Special
