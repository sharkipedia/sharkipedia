class Reference < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :observations
  has_many :trends

  has_one_attached :reference_file

  # taken from altmetric/identifiers
  # https://github.com/altmetric/identifiers/blob/ee2c79beddc5105fe479e8adcd5d22a3fa524fb0/lib/identifiers/doi.rb#L3-L28
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

  validates :doi, format: {
    with: DOI_REGEXP,
    message: "malformed, please follow specification.",
  }, allow_blank: true

  include PgSearch
  pg_search_scope :search_by_name, against: [:name],
                                   using: {
                                     tsearch: {
                                       prefix: true,
                                     },
                                   }
end
