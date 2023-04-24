/// Collection of RegExps that are using in MalangoPod

RegExp textDescriptionRegExp_1 =
    RegExp(r'(<\/p><br>|<\/p><\/br>|<p><br><\/p>|<p><\/br><\/p>)');
RegExp textDescriptionRegExp_2 = RegExp(r'(<p><br><\/p>|<p><\/br><\/p>)');
RegExp numericRegExp = RegExp(r'[0-9۰۱۲۳۴۵۶۷۸۹]');
RegExp numericDoubleRegExp = RegExp(r'[0-9۰۱۲۳۴۵۶۷۸۹.]');
RegExp alphabetCharactersRegExp = RegExp(r'[A-Za-z]');
RegExp alphabetAndNumericRegExp = RegExp(r'[A-Za-z0-9]');
RegExp allCharactersRegExp = RegExp(r'.*');
RegExp emailCharactersRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
RegExp whiteSpaceRegExp = RegExp(r'^\s+|\s+$');
RegExp allCharactersExpectNumbersRegExp =
    RegExp(r'(.*)[^،0123456789۰۱۲۳۴۵۶۷۸۹]');
RegExp phoneFormatExp = RegExp(r'(\d{3})(\d{3})(\d+)');
