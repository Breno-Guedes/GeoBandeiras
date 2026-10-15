# -*- coding: utf-8 -*-
"""Gera assets/dados/paises.json (nomes em PT/EN/ES, continente e dificuldade).
Uso (opcional, o JSON já está pronto): python3 tools/gerar_paises.py
Formato das linhas: codigo|continente|dificuldade|pt|en|es   ('=' repete o nome em português)
Continentes: africa, america, asia, europa, oceania   Dificuldade: f = fácil, d = difícil
"""
import json, os

LINHAS = """
af|asia|d|Afeganistão|Afghanistan|Afganistán
al|europa|d|Albânia|Albania|Albania
dz|africa|f|Argélia|Algeria|Argelia
ad|europa|d|Andorra|=|=
ao|africa|f|Angola|=|=
ag|america|d|Antígua e Barbuda|Antigua and Barbuda|Antigua y Barbuda
ar|america|f|Argentina|=|=
am|asia|d|Armênia|Armenia|Armenia
au|oceania|f|Austrália|Australia|Australia
at|europa|f|Áustria|Austria|Austria
az|asia|d|Azerbaijão|Azerbaijan|Azerbaiyán
bs|america|d|Bahamas|=|=
bh|asia|d|Bahrein|Bahrain|Baréin
bd|asia|f|Bangladesh|=|Bangladés
bb|america|d|Barbados|=|=
by|europa|d|Bielorrússia|Belarus|Bielorrusia
be|europa|f|Bélgica|Belgium|Bélgica
bz|america|d|Belize|=|Belice
bj|africa|d|Benin|=|Benín
bt|asia|d|Butão|Bhutan|Bután
bo|america|f|Bolívia|Bolivia|Bolivia
ba|europa|d|Bósnia e Herzegovina|Bosnia and Herzegovina|Bosnia y Herzegovina
bw|africa|d|Botsuana|Botswana|Botsuana
br|america|f|Brasil|Brazil|=
bn|asia|d|Brunei|=|Brunéi
bg|europa|d|Bulgária|Bulgaria|Bulgaria
bf|africa|d|Burkina Faso|=|=
bi|africa|d|Burundi|=|=
cv|africa|f|Cabo Verde|Cape Verde|=
kh|asia|d|Camboja|Cambodia|Camboya
cm|africa|f|Camarões|Cameroon|Camerún
ca|america|f|Canadá|Canada|=
cf|africa|d|República Centro-Africana|Central African Republic|República Centroafricana
td|africa|d|Chade|Chad|Chad
cl|america|f|Chile|=|=
cn|asia|f|China|=|=
co|america|f|Colômbia|Colombia|Colombia
km|africa|d|Comores|Comoros|Comoras
cg|africa|d|República do Congo|Republic of the Congo|República del Congo
cd|africa|d|República Democrática do Congo|DR Congo|República Democrática del Congo
cr|america|f|Costa Rica|=|=
ci|africa|f|Costa do Marfim|Ivory Coast|Costa de Marfil
hr|europa|f|Croácia|Croatia|Croacia
cu|america|f|Cuba|=|=
cy|europa|d|Chipre|Cyprus|Chipre
cz|europa|f|Tchéquia|Czechia|Chequia
dk|europa|f|Dinamarca|Denmark|Dinamarca
dj|africa|d|Djibuti|Djibouti|Yibuti
dm|america|d|Dominica|=|=
do|america|f|República Dominicana|Dominican Republic|República Dominicana
ec|america|f|Equador|Ecuador|Ecuador
eg|africa|f|Egito|Egypt|Egipto
sv|america|d|El Salvador|=|=
gq|africa|d|Guiné Equatorial|Equatorial Guinea|Guinea Ecuatorial
er|africa|d|Eritreia|Eritrea|Eritrea
ee|europa|d|Estônia|Estonia|Estonia
sz|africa|d|Essuatíni|Eswatini|Esuatini
et|africa|f|Etiópia|Ethiopia|Etiopía
fj|oceania|f|Fiji|=|Fiyi
fi|europa|f|Finlândia|Finland|Finlandia
fr|europa|f|França|France|Francia
ga|africa|d|Gabão|Gabon|Gabón
gm|africa|d|Gâmbia|Gambia|Gambia
ge|asia|d|Geórgia|Georgia|Georgia
de|europa|f|Alemanha|Germany|Alemania
gh|africa|f|Gana|Ghana|Ghana
gr|europa|f|Grécia|Greece|Grecia
gd|america|d|Granada|Grenada|Granada
gt|america|d|Guatemala|=|=
gn|africa|d|Guiné|Guinea|Guinea
gw|africa|d|Guiné-Bissau|Guinea-Bissau|Guinea-Bisáu
gy|america|d|Guiana|Guyana|Guyana
ht|america|f|Haiti|Haiti|Haití
hn|america|d|Honduras|=|=
hu|europa|f|Hungria|Hungary|Hungría
is|europa|f|Islândia|Iceland|Islandia
in|asia|f|Índia|India|India
id|asia|f|Indonésia|Indonesia|Indonesia
ir|asia|f|Irã|Iran|Irán
iq|asia|f|Iraque|Iraq|Irak
ie|europa|f|Irlanda|Ireland|Irlanda
il|asia|f|Israel|=|=
it|europa|f|Itália|Italy|Italia
jm|america|f|Jamaica|=|=
jp|asia|f|Japão|Japan|Japón
jo|asia|d|Jordânia|Jordan|Jordania
kz|asia|d|Cazaquistão|Kazakhstan|Kazajistán
ke|africa|f|Quênia|Kenya|Kenia
ki|oceania|d|Kiribati|=|=
kp|asia|f|Coreia do Norte|North Korea|Corea del Norte
kr|asia|f|Coreia do Sul|South Korea|Corea del Sur
kw|asia|d|Kuwait|=|=
kg|asia|d|Quirguistão|Kyrgyzstan|Kirguistán
la|asia|d|Laos|=|=
lv|europa|d|Letônia|Latvia|Letonia
lb|asia|f|Líbano|Lebanon|Líbano
ls|africa|d|Lesoto|Lesotho|Lesoto
lr|africa|d|Libéria|Liberia|Liberia
ly|africa|d|Líbia|Libya|Libia
li|europa|d|Liechtenstein|=|=
lt|europa|d|Lituânia|Lithuania|Lituania
lu|europa|d|Luxemburgo|Luxembourg|Luxemburgo
mg|africa|d|Madagascar|=|=
mw|africa|d|Malaui|Malawi|Malaui
my|asia|f|Malásia|Malaysia|Malasia
mv|asia|d|Maldivas|Maldives|Maldivas
ml|africa|d|Mali|=|Malí
mt|europa|d|Malta|=|=
mh|oceania|d|Ilhas Marshall|Marshall Islands|Islas Marshall
mr|africa|d|Mauritânia|Mauritania|Mauritania
mu|africa|d|Maurício|Mauritius|Mauricio
mx|america|f|México|Mexico|=
fm|oceania|d|Micronésia|=|=
md|europa|d|Moldávia|Moldova|Moldavia
mc|europa|d|Mônaco|Monaco|Mónaco
mn|asia|d|Mongólia|Mongolia|Mongolia
me|europa|d|Montenegro|=|=
ma|africa|f|Marrocos|Morocco|Marruecos
mz|africa|f|Moçambique|Mozambique|Mozambique
mm|asia|d|Mianmar|Myanmar|Birmania (Myanmar)
na|africa|d|Namíbia|Namibia|Namibia
nr|oceania|d|Nauru|=|=
np|asia|f|Nepal|=|=
nl|europa|f|Países Baixos|Netherlands|Países Bajos
nz|oceania|f|Nova Zelândia|New Zealand|Nueva Zelanda
ni|america|d|Nicarágua|Nicaragua|Nicaragua
ne|africa|d|Níger|Niger|Níger
ng|africa|f|Nigéria|Nigeria|Nigeria
mk|europa|d|Macedônia do Norte|North Macedonia|Macedonia del Norte
no|europa|f|Noruega|Norway|Noruega
om|asia|d|Omã|Oman|Omán
pk|asia|f|Paquistão|Pakistan|Pakistán
pw|oceania|d|Palau|=|=
pa|america|f|Panamá|Panama|Panamá
pg|oceania|f|Papua-Nova Guiné|Papua New Guinea|Papúa Nueva Guinea
py|america|f|Paraguai|Paraguay|Paraguay
pe|america|f|Peru|=|Perú
ph|asia|f|Filipinas|Philippines|Filipinas
pl|europa|f|Polônia|Poland|Polonia
pt|europa|f|Portugal|=|=
qa|asia|d|Catar|Qatar|Catar
ro|europa|f|Romênia|Romania|Rumania
ru|europa|f|Rússia|Russia|Rusia
rw|africa|d|Ruanda|Rwanda|Ruanda
kn|america|d|São Cristóvão e Névis|Saint Kitts and Nevis|San Cristóbal y Nieves
lc|america|d|Santa Lúcia|Saint Lucia|Santa Lucía
vc|america|d|São Vicente e Granadinas|Saint Vincent and the Grenadines|San Vicente y las Granadinas
ws|oceania|f|Samoa|=|=
sm|europa|d|San Marino|=|=
st|africa|d|São Tomé e Príncipe|Sao Tome and Principe|Santo Tomé y Príncipe
sa|asia|f|Arábia Saudita|Saudi Arabia|Arabia Saudita
sn|africa|f|Senegal|=|=
rs|europa|d|Sérvia|Serbia|Serbia
sc|africa|d|Seicheles|Seychelles|=
sl|africa|d|Serra Leoa|Sierra Leone|Sierra Leona
sg|asia|f|Singapura|Singapore|Singapur
sk|europa|d|Eslováquia|Slovakia|Eslovaquia
si|europa|d|Eslovênia|Slovenia|Eslovenia
sb|oceania|d|Ilhas Salomão|Solomon Islands|Islas Salomón
so|africa|d|Somália|Somalia|Somalia
za|africa|f|África do Sul|South Africa|Sudáfrica
ss|africa|d|Sudão do Sul|South Sudan|Sudán del Sur
es|europa|f|Espanha|Spain|España
lk|asia|d|Sri Lanka|=|=
sd|africa|d|Sudão|Sudan|Sudán
sr|america|d|Suriname|=|Surinam
se|europa|f|Suécia|Sweden|Suecia
ch|europa|f|Suíça|Switzerland|Suiza
sy|asia|d|Síria|Syria|Siria
tj|asia|d|Tajiquistão|Tajikistan|Tayikistán
tz|africa|f|Tanzânia|Tanzania|Tanzania
th|asia|f|Tailândia|Thailand|Tailandia
tl|asia|d|Timor-Leste|=|Timor Oriental
tg|africa|d|Togo|=|=
to|oceania|d|Tonga|=|=
tt|america|d|Trinidad e Tobago|Trinidad and Tobago|Trinidad y Tobago
tn|africa|f|Tunísia|Tunisia|Túnez
tr|asia|f|Turquia|Turkey|Turquía
tm|asia|d|Turcomenistão|Turkmenistan|Turkmenistán
tv|oceania|d|Tuvalu|=|=
ug|africa|d|Uganda|=|=
ua|europa|f|Ucrânia|Ukraine|Ucrania
ae|asia|f|Emirados Árabes Unidos|United Arab Emirates|Emiratos Árabes Unidos
gb|europa|f|Reino Unido|United Kingdom|=
us|america|f|Estados Unidos|United States|=
uy|america|f|Uruguai|Uruguay|Uruguay
uz|asia|d|Uzbequistão|Uzbekistan|Uzbekistán
vu|oceania|d|Vanuatu|=|=
ve|america|f|Venezuela|=|=
vn|asia|f|Vietnã|Vietnam|Vietnam
ye|asia|d|Iêmen|Yemen|=
zm|africa|d|Zâmbia|Zambia|Zambia
zw|africa|d|Zimbábue|Zimbabwe|Zimbabue
"""

def main():
    raiz = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
    paises = []
    for linha in LINHAS.strip().splitlines():
        cod, cont, dif, pt, en, es = linha.split("|")
        en = pt if en == "=" else en
        es = pt if es == "=" else es
        paises.append({
            "codigo": cod,
            "continente": cont,
            "dificuldade": "facil" if dif == "f" else "dificil",
            "nomes": {"pt": pt, "en": en, "es": es},
        })
    paises.sort(key=lambda p: p["nomes"]["pt"])
    destino = os.path.join(raiz, "assets", "dados", "paises.json")
    with open(destino, "w", encoding="utf-8") as f:
        json.dump(paises, f, ensure_ascii=False, indent=1)
    print(len(paises), "países gravados em", destino)

if __name__ == "__main__":
    main()
