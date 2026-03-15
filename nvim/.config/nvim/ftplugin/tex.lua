vim.cmd.compiler("tex")

-- Setting the compiler to "tex" will cause Vim to check if there's a Makefile
-- present. If there is, it won't change makeprg, which is what we want. If
-- not, it sets the compiler to "latex -interaction=nonstopmode" which doesn't
-- really do what I want, it expects a parameter and produces DVI output. For
-- non-serious documents (i.e. ones without a Makefile), I generally want to
-- compile with pdflatex and the source is the document I'm editing, so replace
-- makeprg th have :make with no arguments compile the current buffer to a PDF.
if vim.split(vim.opt.makeprg:get(), " ")[1] == "latex" then
    vim.opt_local.makeprg = "pdflatex -no-shell-escape -interaction=nonstopmode %"
end
