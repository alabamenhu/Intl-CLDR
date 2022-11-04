module AdlamDigits {
  sub adlam-digits($number) is export { $number.trans: [ '0' .. '9' ] => [ "\x1E950" ... "\x1E959"] }
}

module ArabicDigits {
  sub arabic-digits($number) is export { $number.trans: [ '0' .. '9' ] => [ "٠" ... "٩"] }
}
