syntax match gitcommitIssue "\(^\|\s\|/\|(\)\zs#\d\{1,4}\>"
syntax match gitcommitUsername "\(^\|\s\|(\)\zs@\(\w\|\d\|\.\|-\)\{1,15}\>"
syntax match gitcommitAbbreviatedHash "\<\x\{7,40}\>"

highlight def link gitcommitIssue Underlined
highlight def link gitcommitUsername Title
