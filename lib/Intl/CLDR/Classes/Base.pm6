unit module Base;
use Intl::CLDR::Immutability;
use Intl::CLDR::Classes::Calendar;

class CLDR-Language is CLDR-Item is export {
  has $!parent;
  has $.calendars;
#  has $.calendars;
#  has $.character-labels;
#  has $.delimiters;
#  has $.list-patterns;
#  has $.locale-display-names;
#  has $.numbers;
#  has $.typographic-names;
#  has $.units;

  # because TWEAK isn't available for Hash subclasses, see
  # https://github.com/rakudo/rakudo/issues/2716
  method new ($parent?){
    self.bless!bind-init($parent);
  }

  submethod !bind-init ($parent) {
      $!parent = $parent;
      self.Hash::BIND-KEY: 'calendars',          $!calendars;
      #`<<<< Uncomment out as attributes are handled specially
      #self.Hash::BIND-KEY: 'characters',         $!calendars;
      #self.Hash::BIND-KEY: 'characterLabels',    $!character-labels;
      #self.Hash::BIND-KEY: 'delimiters',         $!delimiters;
      #self.Hash::BIND-KEY: 'listPatterns',       $!list-patterns;
      #self.Hash::BIND-KEY: 'localeDisplayNames', $!locale-display-names;
      #self.Hash::BIND-KEY: 'numbers',            $!calendars;
      #self.Hash::BIND-KEY: 'typographicNames',   $!typographic-names;
      #self.Hash::BIND-KEY: 'units',              $!units;
      >>>>
      self;
  }

  method ADD-TO-DATABASE (@branch, $offset = @branch - 1) {
      self.Hash::ASSIGN-KEY: @branch[1], @branch[0]
          andthen return if $offset == 1;

      my $key = @branch[$offset];
      unless self.Hash::AT-KEY($key) {
          given $key {
              when 'calendars' { $!calendars = CLDR-Calendars.new: self }
              default          { self.Hash::ASSIGN-KEY: $key, CLDR-Item.new }
          }
      }
      self.Hash::AT-KEY($key).ADD-TO-DATABASE: @branch, $offset - 1
  }

  #`<<<<<
  multi method ADD-TO-DATABASE (+@branch where     2) { self.Hash::ASSIGN-KEY(@branch.head, @branch.tail) }
  multi method ADD-TO-DATABASE (+@branch where * > 2) {
    unless self.Hash::AT-KEY(@branch.head) {
      given @branch.head {
        when 'calendars' { $!calendars = CLDR-Calendars.new(self) }
        default          { self.Hash::ASSIGN-KEY: @branch.head, CLDR-Item.new }
      }
    }
    self.Hash::AT-KEY(@branch.head).ADD-TO-DATABASE: @branch[1..*]
  }
  >>>>>

  method clone { ... }
}
