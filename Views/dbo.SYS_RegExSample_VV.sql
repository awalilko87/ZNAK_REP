SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[SYS_RegExSample_VV]
AS
with reg as(

		  SELECT [ID]=1, [REGEX]=N'a,A,b,B,c,C,d,1,2,3,4,!,#,....', [DESCRYPTION] = 'znaki zwyczajne'
UNION ALL SELECT [ID]=2, [REGEX]=N'^, $, *, +, ?, . ,(, ), [, ], {, }, \', [DESCRYPTION] = 'znaki specjalne - meta znaki'
UNION ALL SELECT [ID]=3, [REGEX]=N'\,^,-,]', [DESCRYPTION] = 'znaki specjalne rozpoznawana wewnątrz nawiasów kwadratowych'
UNION ALL SELECT [ID]=4, [REGEX]=N' .', [DESCRYPTION] = 'oznacza dowolny pojedynczy znak z wyjątkiem znaku nowego wiersza'
UNION ALL SELECT [ID]=5, [REGEX]=N'*', [DESCRYPTION] = 'treść stojąca przed tym symbolem może powtórzyć się zero lub więcej razy'
UNION ALL SELECT [ID]=6, [REGEX]=N'+', [DESCRYPTION] = 'treść stojąca przed tym symbolem musi powtórzyć się jeden lub więcej razy'
UNION ALL SELECT [ID]=7, [REGEX]=N'?', [DESCRYPTION] = 'treść stojąca przed tym symbolem może wystąpić najwyżej jeden raz (być może zero); to samo co {0,1}'
UNION ALL SELECT [ID]=8, [REGEX]=N'{n}', [DESCRYPTION] = 'treść stojąca przed tym symbolem musi powtórzyć się {n} razy'
UNION ALL SELECT [ID]=9, [REGEX]=N'{m,n}', [DESCRYPTION] = 'treść stojąca przed tym symbolem musi powtórzyć się od m do n razy'
UNION ALL SELECT [ID]=10, [REGEX]=N'^', [DESCRYPTION] = 'początek wiersza'
UNION ALL SELECT [ID]=11, [REGEX]=N'$', [DESCRYPTION] = 'koniec wiersza'
UNION ALL SELECT [ID]=12, [REGEX]=N'\', [DESCRYPTION] = 'znak poprzedzony odwrotnym ukośnikiem pozwala użyć znaku specjalnego jako normalnego znaku'
UNION ALL SELECT [ID]=13, [REGEX]=N' | ', [DESCRYPTION] = 'operator "lub" albo treść stojąca przed tym symbolem albo następne wyrażenie muszą pasować ,np. Ala|Ola - czyli w danym wyrażeniu może wystąpić słowo Ala lub Ola'
UNION ALL SELECT [ID]=14, [REGEX]=N' ()', [DESCRYPTION] = 'nawiasy zwykłe w nim zawieramy podwzorzec np. Fizy(k|cy) pasuje do Fizyk i Fizycy'
UNION ALL SELECT [ID]=15, [REGEX]=N' []', [DESCRYPTION] = 'grupowanie - zestaw znaków między nawiasami kwadratowymi oznacza dowolny znak objęty nawiasami kwadratowymi (np. pi[wk]o pasuje do piwo i piko, [a-z] oznacza litery od a do z)'
UNION ALL SELECT [ID]=16, [REGEX]=N'\e', [DESCRYPTION] = 'znak "escape"'
UNION ALL SELECT [ID]=17, [REGEX]=N'\f', [DESCRYPTION] = 'nowa strona'
UNION ALL SELECT [ID]=18, [REGEX]=N'\n', [DESCRYPTION] = 'koniec linii'
UNION ALL SELECT [ID]=19, [REGEX]=N'\r', [DESCRYPTION] = 'powrót karetki'
UNION ALL SELECT [ID]=20, [REGEX]=N'\t', [DESCRYPTION] = 'oznacza tabulację'
UNION ALL SELECT [ID]=21, [REGEX]=N'\cx', [DESCRYPTION] = 'oznacza "control-x", x jest dowolnym znakiem'
UNION ALL SELECT [ID]=22, [REGEX]=N'\xhh', [DESCRYPTION] = 'znak o kodzie szesnastkowym'
UNION ALL SELECT [ID]=23, [REGEX]=N'\a', [DESCRYPTION] = 'znak dźwiękowy czyli "bel"'
UNION ALL SELECT [ID]=24, [REGEX]=N'\w', [DESCRYPTION] = 'litera lub cyfra; to samo co [0-9A-Za-z]'
UNION ALL SELECT [ID]=25, [REGEX]=N'\W', [DESCRYPTION] = 'ani litera ani cyfra'
UNION ALL SELECT [ID]=26, [REGEX]=N'\s', [DESCRYPTION] = 'biały znak; to samo co [ \t\n\r\f]'
UNION ALL SELECT [ID]=27, [REGEX]=N'\S', [DESCRYPTION] = 'nie biały znak'
UNION ALL SELECT [ID]=28, [REGEX]=N'\d', [DESCRYPTION] = 'znak cyfra; to samo co [0-9]'
UNION ALL SELECT [ID]=29, [REGEX]=N'\D', [DESCRYPTION] = 'znak nie będący cyfrą'
UNION ALL SELECT [ID]=30, [REGEX]=N'\b', [DESCRYPTION] = 'backspace (0x08) (tylko jeśli występuje w specyfikacji zakresu)'
UNION ALL SELECT [ID]=31, [REGEX]=N'\b', [DESCRYPTION] = 'granica słowa (jeśli nie występuje w specyfikacji zakresu)'
UNION ALL SELECT [ID]=32, [REGEX]=N'\B', [DESCRYPTION] = 'granica nie słowa'
UNION ALL SELECT [ID]=33, [REGEX]=N'/<', [DESCRYPTION] = 'początek słowa'
UNION ALL SELECT [ID]=34, [REGEX]=N'/>', [DESCRYPTION] = 'koniec słowa'
UNION ALL SELECT [ID]=35, [REGEX]=N'\d\d\d\d-\d\d-\d\d', [DESCRYPTION] = 'Data'
UNION ALL SELECT [ID]=36, [REGEX]=N'\d\d\d\d-\d\d-\d\d:\d\d:\d\d:\d\d', [DESCRYPTION] = 'Data z czasem'
UNION ALL SELECT [ID]=39, [REGEX]=N'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$', [DESCRYPTION] = 'adres email'
UNION ALL SELECT [ID]=40, [REGEX]=N'^(([\w_]+)-*\.?)+@[\w](([\w]+)-?_?\.?)+([a-z]{2,4})$', [DESCRYPTION] = 'adres email'
UNION ALL SELECT [ID]=41, [REGEX]=N'^[A-Z]{2}([ ]+|-)?[0-9]{2}[0-9A-Z]{3}$', [DESCRYPTION] = 'poporawny numer rejestracyjny'
)
select * from reg
GO