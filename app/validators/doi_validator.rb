class DOIValidator < ActiveModel::Validator
  def validate(record)
    return if record.doi.blank? || record.doi =~ DOI_REGEXP

    record.errors.add :doi, "malformed, please follow specification."
  end

  # The regex below was originally taken from altmetric/identifiers
  # https://github.com/altmetric/identifiers/blob/ee2c79beddc5105fe479e8adcd5d22a3fa524fb0/lib/identifiers/doi.rb#L3-L28
  #
  # The MIT License (MIT)
  #
  # Copyright (c) 2016-2017 Altmetric LLP
  #
  # Permission is hereby granted, free of charge, to any person obtaining a copy
  # of this software and associated documentation files (the "Software"), to deal
  # in the Software without restriction, including without limitation the rights
  # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  # copies of the Software, and to permit persons to whom the Software is
  # furnished to do so, subject to the following conditions:
  #
  # The above copyright notice and this permission notice shall be included in
  # all copies or substantial portions of the Software.
  #
  # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  # THE SOFTWARE.
  DOI_REGEXP = %r{
    \b
    10                                        # Directory indicator (always 10)
    \.
    (?:
      # ISBN-A
      97[89]\.                                # ISBN (GS1) Bookland prefix
      \d{2,8}                                 # ISBN registration group element and publisher prefix
      /                                       # Prefix/suffix divider
      \d{1,7}                                 # ISBN title enumerator and check digit
      |
      # DOI
      \d{4,9}                                 # Registrant code
      /                                       # Prefix/suffix divider
      (?:
        # DOI suffix
        [^[:space:]]+;2-[\#0-9a-z]            # Early Wiley suffix
        |
        [^[:space:]]+                         # Suffix...
        \([^[:space:])]+\)                    # Ending in balanced parentheses...
        (?![^[:space:]\p{P}])                 # Not followed by more suffix
        |
        [^[:space:]]+(?![[:space:]])\p{^P}    # Suffix ending in non-punctuation
      )
    )
  }x

  private_constant :DOI_REGEXP
end
