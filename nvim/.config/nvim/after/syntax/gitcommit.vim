syntax match gitcommitIssue "\(^\|\s\|/\|(\)\zs#\d\{1,4}\>"
syntax match gitcommitUsername "\(^\|\s\|(\)\zs@\(\w\|\d\|\.\|-\)\{1,15}\>"
syntax match gitcommitAbbreviatedHash "\<\x\{7,12}\>"

highlight def link gitcommitIssue Underlined
highlight def link gitcommitUsername @markup.strong
highlight def link gitcommitAbbreviatedHash gitcommitHash
