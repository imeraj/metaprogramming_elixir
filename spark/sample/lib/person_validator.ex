defmodule Sample.PersonValidator do
  use Sample.Validator,
    fragments: [Sample.PersonValidator.BaseFeilds, Sample.PersonValidator.ContactFeilds]
end
