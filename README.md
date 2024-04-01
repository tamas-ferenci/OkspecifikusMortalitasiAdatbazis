Okspecifikus Mortalitási Adatbázis
================
Ferenci Tamás (<https://www.medstat.hu/>)

- [Előhang: mi az, hogy
  epidemiológia?](#előhang-mi-az-hogy-epidemiológia)
- [Kik, mikor és hol betegek?](#kik-mikor-és-hol-betegek)
- [Miért betegek?](#miért-betegek)
- [Az adatok begyűjtése és
  előkészítése](#az-adatok-begyűjtése-és-előkészítése)
- [Az adatok validációja](#az-adatok-validációja)
- [A weboldal](#a-weboldal)
- [Továbbfejlesztési lehetőségek](#továbbfejlesztési-lehetőségek)

Az Okspecifikus Mortalitási Adatbázis a
<https://research.physcon.uni-obuda.hu/OkspecifikusMortalitasiAdatbazis/>
címen érhető el.

Jelen írás két fő célt szolgál: az első felében egy részletes, reményeim
szerint teljesen közérhető magyarázatot ad az adatok értelmezéséhez és
felhasználásához, rámutatva a limitációkra és buktatókra is. Ez utóbbit
különösen fontosnak tartom, mert az adatok hibás felhasználása sok
nehézség és félreértés forrása; igyekszem a legfontosabb ilyeneket
alaposan bemutatni.

Az írás második fele egy technikai leírás, mely az adatbázis
előkészítésének lépéseit, az adatok validációját, valamint a weboldal
felépítését mutatja be. Valamennyi felhasznált kódot teljes
terjedelmében közlöm, így az összes számításom reprodukálható. Ezt
fontosnak tartom a nyílt tudomány, a transzparencia jegyében, elsősorban
azért, hogy az esetleges hibák, illetve jobb elemzési lehetőségek
könnyebben felszínre kerüljenek.

## Előhang: mi az, hogy epidemiológia?

Régebben tanítottam népegészségtant orvostanhallgatóknak, és ezeken a
kurzusokon mindig azt a – teljesen személyes, és tudományosan lehet,
hogy nem megalapozott – definíciót adtam az epidemiológia fogalmára,
hogy az a tudomány, ami választ akar adni a következő kérdésre: *miért
betegek az emberek*? Majd azzal folytattam, hogy ha kicsit bővíteni
akarjuk a képet, akkor azt mondanám, hogy az a tudomány, ami a következő
három kérdésre igyekszik válaszolni: *kik, mikor és hol betegek*? Rögtön
hozzátéve, hogy valójában ezek a kérdések is sokszor pont azért
érdekesek, mert segítenek megoldani a fő feladatot: azt gondoljuk, hogy
ott, akkor és azok körében, akik betegek, van valami oka annak, hogy épp
ők, akkor és ott betegek – ezért fontos ezek feltárása.

Mint az a fentiekből is látható, a feladat kettős: be kell gyűjteni a
megfelelő adatokat a „kik, mikor és hol betegek?” kérdésre, majd ezek
alapján levonni a következtetést a „miért betegek?” kérdésre nézve. Első
ránézésre az előbbi csak egy technikai kérdés és a második a fogós
feladat. Valójában már az első is sok nem nyilvánvaló problémát vet fel
– de a másodiknál nehéz lenne vitatkozni a fogós jelzővel. Tekintsük
most át mindkét lépést!

## Kik, mikor és hol betegek?

Első lépésben megbeszéljük, hogy miért halálozási adatokat használunk
(noha eddig mindenhol betegségről volt szó!), utána pedig megnézzük az
adatok lebontását a három említett kérdés mentén.

### Halálozási és megbetegedési adatok

Az eddigiekben végig „betegség” szerepelt a szövegben: ami érdekes, az
az adott populációban adott időszakban fellépő új megbetegedések száma.
(Szép szóval ezt incidenciának szokták hívni.) Ehhez képest az
adatbázisunk halálozási adatokat – mortalitást, tehát az adott
időszakban adott betegségbe belehalt emberek számára vonatkozó
információkat – tartalmaz. De miért? Milyen jogon tértünk át az egyikről
a másikra, incidenciáról mortalitásra, tehát előfordulásról halálozásra?

Fontos rögzíteni, hogy ez valóban egyfajta kényszermegoldás sok
szempontból. De még ezekben az esetekben is védhető kényszermegoldás,
illetve nagyon sokszor nem is tudunk mást használni, bármennyire is jó
vagy nem jó. A következőkben az idevágó szempontokat tekintjük át.

#### Miért jók a halálozási adatok?

1.  Elérhetőek betegségek egy széles körére

Szemben a halálozással, a betegségek előfordulására vonatkozó adatok
általában sokkal szűkebb körben, azaz sokkal kevesebb betegségre
vonatkozóan érhetőek el. A halálozásokból ugyanis minden egyes esetet
besorolnak halálok szerint és nyilvánosan jelentenek, addig egy betegség
puszta fellépésére vonatkozó információ begyűjtése általában komoly
többlet-energia befektetését igényli, hiszen ilyen adatot – szemben a
halálozással – rutinszerűen nem gyűjtenek a népegészségügyi rendszerek.
Alapvetően három megoldási lehetőség jön szóba ha előfordulásra
vonatkozó adatot szeretnénk gyűjteni; hogy jobban megértsük az ezzel
kapcsolatos nehézségeket, tekintsük át ezeket nagyon röviden:

- Az egyik megoldási lehetőség ad hoc vizsgálatok szervezése. (Például
  egy mintavétellel történő felmérés – jó esetben véletlenszerűen a
  populációból, rosszabb esetben ún. kényelmi mintaként, például
  egyetlen, általunk könnyen lekérdezhető kórház adatainak
  feldolgozásával.) Ez kevesebb erőforrást igényel, de csak egy
  pillanatfelvételt ad, és semmiképp nem teljeskörű, kényelmi minta
  esetén pedig erősen kérdéses is az általánosíthatósága.
- A másik lehetőség az ún. adminisztratív/finanszírozási adatok
  felhasználása. Az alapötlet, hogy a kórházak amúgy is jelentenek
  finanszírozási célból adatokat – miért ne használjuk fel ezt
  epidemiológiai célokra is? Csakugyan, ha valaki egészségügyi
  ellátásban részesül, akkor keletkezik róla egy adatsor, amit
  beküldenek a NEAK-ba, benne a személy nemével, életkorával,
  lakhelyével, betegségével, az elvégzett beavatkozással; ebből tényleg
  kiolvasható lehet a megbetegedés fellépése. Ez nagyon csábítóan
  hangzik, hiszen az erőforrás-igénye csekély (amúgy is begyűjtött
  adatokat dolgozunk fel), de mégis teljeskörű és folyamatosan frissülő
  az adatbázis, legalábbis a közfinanszírozott ellátásokra vonatkozóan.
  Bár ez eddig nagyon jól hangzik, a módszernek vannak hátrányai is,
  egyrészt az adatminőség (ezeket a jelentéseket a kórházak rutinszerűen
  meghamisítják, hogy „optimalizálják” a finanszírozásukat), másrészt a
  klinikai adatok hiánya (azt tudjuk, hogy valakit megröntgeneztek, de
  azt nem tudjuk, hogy mi volt a röngtenképen, azt tudjuk, hogy az alany
  hány éves, de azt nem tudjuk, hogy dohányzik-e). Ezzel együtt is, ma
  már egyre több ilyen vizsgálat készül; egy példa tisztán akadémiai
  célokat szolgáló ilyen kutatásra a
  [HUNVASCDATA](https://hunvascdata.hu/)-projekt.
- Végezetül a harmadik lehetőség a betegségregiszterek használata. Ez
  szó szerint véve „a” megoldás a problémára, hiszen a regiszter
  definíció szerint azt jelenti, hogy valamely megbetegedés
  előfordulásáról a teljesség igényével történő gyűjtés. (Tipikusan
  jogszabály írja el a kötelező jelentést az egészségügyi ellátóknak.)
  Ez látszólag az ideális megoldás: teljeskörű, folyamatos, validálható
  adatminőségű, részletgazdag klinikai adatokat is tartalmazhat,
  egyetlen apró problémája van: az, hogy hatalmas az erőforrásigénye.
  Nem csak „forintban” értve, hanem az adatszolgáltatói teherre nézve
  is, hiszen ez azt is jelenti, hogy az észlelő orvosoknak a betegek
  után egy plusz jelentést is ki kell tölteniük, és feltölteni a
  regiszterbe.

A jogszabály szerint Magyarországon több mint egy tucat regiszter kell,
hogy [működjön](https://njt.hu/jogszabaly/2018-49-20-5H), ezekből
gyakorlatilag kettő az aminek értelmezhető, ténylegesen teljeskörű,
folyamatosan frissülő, kívülről is látható – publikációkban megjelenő,
weboldalon lekérdezhető – aktivitása van, a [Nemzeti
Szívinfarktusregiszter](https://nszr.gokvi.hu/ir/fooldal) és a [Nemzeti
Rákregiszter](https://onkol.hu/nemzeti-rakregiszter-es-biostatisztikai-kozpont/).
Az összes többi regiszterről még én sem tudom, hogy mit csinálnak, van
ami elvileg működik, de kívülről nézve aligha betöltve a funkcióját (a
szívelégtelenség regiszter 2021-ben eredményként [számolt
be](https://mkardio.hu/hirek.aspx?nid=106368) arról, hogy 2015 óta
összesen 1600 beteget bevontak – miközben Magyarországon majdnem 10 ezer
*halál* történik ebből, *évente*), van, aminek a nevére
[rákeresve](https://www.google.com/search?client=firefox-b-d&q=%22Feln%C5%91tt+Sz%C3%ADvseb%C3%A9szeti+Regiszter%22)
kizárólag a jogszabály szövegét kapjuk meg találatként…

Remélem a fentiekkel tudtam érzékeltetni, hogy mi az oka annak, hogy
előfordulásra vonatkozó adatok csak betegségek egy szűk körére érhetőek
el, valamint, hogy az sem várható, hogy ez lényegesen megváltozzon a
közeljövőben.

2.  Ez különösen igaz, ha időben visszafelé megyünk

Az előbbi állítás végképp igaz, ha szeretnénk múltbeli adatokat is
vizsgálni; minél messzebb megyünk vissza, annál inkább. A Nemzeti
Szívinfarktusregiszter 2014 óta működik mint teljeskörű regiszter, a
Nemzeti Rákregiszter 2000 óta. Nyugati regisztereknél van példa nagyobb
időtartamra, de összességében véve legjobb esetben is néhány évtizedről
beszélünk, ami az előfordulás-jellegű adatok elérhetőségét illeti. Ehhez
képest az angol haláloki adatok 1851-re is
[elérhetőek](http://doc.ukdataservice.ac.uk/doc/3552/mrdoc/pdf/guide.pdf),
de a londoniakat már 1603-tól (!) minden évben nyomtatásban
[közlik](https://www.thelancet.com/journals/lancet/article/PIIS0140-6736(20)30725-X/fulltext).

3.  A halálozás sokszor az egyik legfontosabb mutatója egy betegség
    terhének

Ha nem egyszerűen a betegség előfordulása érdekel minket, hanem a
betegség jelentette teher, akkor nagyon sok szempont merül fel:
szenvedés, maradványtünetekkel gyógyulás, munkából kiesés, egészségügyi
ellátórendszer igénybevétele és így tovább. Ezek közül a halálozás
azonban kiemelkedik, egyrészt mert egyértelműen definiált és
egyértelműen mérhető (mi az, hogy „szenvedés” és hogyan lehet
számszerűen lemérni?), másrészt mert sok esetben ez a legfontosabb,
legnagyobb relevanciával bíró szempont, a köznapi szóhasználatban és
népegészségügyi szempontból is.

4.  Ha a halálozási arány állandó, akkor a halálozás az incidenciát is
    jellemzi

A betegségbe belehaló emberek száma egy szorzat: a megbetegedő emberek
száma szorozva a halálozási aránnyal. Amennyiben feltételezzük, hogy ez
utóbbi állandó, akkor a halálozás valójában igenis méri az incidenciát
is! Igen, a konkrét szám nem fog stimmelni (hacsak a halálozási arány
nem 100%), de a *relatív viszonyok* rendben lesznek: ha kétszer annyi
halálozás van, akkor tudhatjuk, hogy az előfordulás is kétszeresére
nőtt. Amennyiben az „állandó” alatt azt értjük, hogy nem változik időben
egy országban, akkor az adott ország különböző időszaki adatai vethetőek
egybe ilyen módon, ha pedig különböző országokban is ugyanaz a
halálozási arány, akkor még a különböző országok adatai is
összevethetőek (mondhatjuk, hogy ahol kétszer akkorra a halálozás, ott
kétszer annyi megbetegedés is van).

#### Milyen bajai vannak a halálozási adatoknak?

1.  A haláloki besorolás problémái

Ez a kérdés a koronavírus-járvány alatt hatalmas publicitást kapott. Egy
ahhoz kapcsolódó
[írásomban](https://github.com/tamas-ferenci/ExcessMortEUR) részletesen
[kifejtettem](https://github.com/tamas-ferenci/ExcessMortEUR?tab=readme-ov-file#a-hal%C3%A1loki-statisztik%C3%A1k-probl%C3%A9m%C3%A1i)
a problémakört, itt szinte szó szerint meg tudom ismételni az akkor
leírtakat: gond az, hogy a haláloki statisztikákban mindenkit egy, és
csak egy halálokhoz kell besorolni. (Magán a halottvizsgálati
bizonyítványon ennél komplexebb haláloki helyzet is feltüntethető, de a
végső statisztikában ez nem fog látszni, csak egy pontosan definiált,
ún. előztetési eljárással kiválasztott halálok, amit statisztikai
közlésre kiválasztott elsődleges haláloknak szoktak nevezni.) A probléma
az, hogy az embereknek sokszor nem egyetlen halálokuk van: elveszítünk
egy szívelégtelen, cukorbeteg alanyt stroke-ban; ő akkor most mibe halt
bele? A szívelégetelenségbe? A cukorbetegségbe? A stroke-ba?

Ritkák a vegytiszta esetek, mégpedig mindkét irányban ritkák: hogy egy
egyébként makkegészséges alanyt elvisz egy stroke vagy hogy egy
stroke-os beteg fejére rádől egy kémény az utcán. Ezek a tiszta esetek,
amikor 100% vagy 0% a stroke hozzájárulása a halálozáshoz, de a valódi
történetek többsége nem ilyen, hanem szürke zóna, mint azt az előző
bekezdés példája is mutatja.

Ráadásul nem arról van szó, hogy ez „bonyolult” probléma (és majd jövőre
okosabbak leszünk, és megoldjuk), hanem arról, hogy ez *megoldhatatlan*
probléma. Valamennyi ok *hozzájárult* a halálához, nyilván nem tett jót,
hogy szívelégtelen, nem tett jót, hogy cukorbeteg, tehát, ha szigorúan
vesszük, valami olyasmit kellene mondani, hogy 33 százalékban a
szívelégtelenségbe halt bele, 19 százalékban a cukorbetegségbe és 48
százalékban a stroke-ba. (Természetesen ezek a számok teljesen
hasraütésszerűek.) Hiába is lenne *elvileg* ez a helyes, az orvosi
realitásnak megfelelő kép, ilyet nem csinálunk – annyiban érthető módon
is, hogy ember legyen a talpán, aki ezeket a százalékokat megmondja.

Ez tehát a probléma; annyit azért fontos hangsúlyozni, hogy a dolog egy
részletekbe menően szabályozott, egységes algoritmus alapján zajlik (ez
nyilvánosan elolvasható, mind a
[KSH-nál](https://www.ksh.hu/docs/hun/info/02osap/torveny/d159006_2.doc),
mind a
[WHO-nál](https://icd.who.int/browse10/Content/statichtml/ICD10Volume2_en_2019.pdf)),
tehát bár a problémára nincs varázsütésszerű megoldás, de legalább az
elmondható, hogy a pontos besorolási döntés, még ha nem is vitathatlan,
de jó esetben legalább egységes országok között is, és időben is.

2.  Az adatminőség kérdése

Úgy tűnhet, hogy ilyen szempontból nincs nagy gond, sőt, valójában még
jobb is a helyzet, mint az incidencia-jellegű adatoknál, hiszen míg egy
diagnózist el lehet nézni, azért legkésőbb a halálnál, felboncolva az
alanyt, csak kiderül egész biztosan, hogy mi baja volt. Valójában azért
ez ennyire biztosan nem igaz (kezdve azzal, hogy egyáltalán nincs minden
elhunyt felboncolva; Magyarországon 2021-ben 23% volt a [boncolási
arány](https://gateway.euro.who.int/en/indicators/hfa_545-6410-autopsy-rate-for-all-deaths)
és ez még egy kiugróan magas szám, a legtöbb nyugati országban ez a
10%-ot sem éri el).

Az első kérdés a használt osztályozási rendszer, a Betegségek Nemzetközi
Osztályozása (röviden BNO) ami meghatározza, hogy milyen halálokok
léteznek és hogy azokba milyen algoritmus szerint kell besorolni az
elhunytakat. A gond az, hogy az orvosi tudás bővülésével ez folyamatosan
változik, tipikusan bővül, mégpedig elég drámaian: a BNO 1900-ban
bevezetett első változata 191 kódot tartalmazott, a 2022-ben elindított
11. revízió pedig 17 ezret… Közben bizonyos kódokat törölnek is, vagy
egybevonnak másokkal, a bővülés sem feltétlenül új betegségek
megjelenését jelenti, hanem meglevőek részletesebb szétbontását és így
tovább. Az [külön
tudomány](https://www.tandfonline.com/doi/abs/10.1080/01615440.1996.10112731),
hogy az eltérő verziókat hogyan kell összekapcsolni, de látszik, hogy ez
tökéletesen soha nem tehető meg. Ez eleve korlátozza az egységességet,
ha különböző időpontokról beszélünk.

Valójában ennél kicsit rosszabb a helyzet, mert egy revízió érvényességi
időtartamán belül is lehetnek változások. Ezt azért említem külön, mert
a magyar adatokat érinti: 1995-től 2022-ig a 10. revízió volt érvényben,
mégis, 2005-től érzékelhetően megváltoztak a számok. (Az össz-halálozás
természetesen adott, így ez lényegében a különböző kategóriák közötti
átrendeződést jelenti.) Ennek az oka egyrészt, hogy ekkor [tértek
át](https://www.ksh.hu/docs/hun/modsz/nep_modsz.html) a KSH-nál az
automatikus, gépi haláloki besorolási rendszerre a korábbi kézi
besorolás helyett, egy új halottvizsgálati bizonyítvány formátum,
valamint szigorúbb orvos-szakmai ellenőrzés elindításával együtt,
másrészt ekkor [vezették
át](http://diploma.uni-sopron.hu/1890/1/kplhi1604.pdf) egyben az 1995
óta a WHO által kiadott apróbb, revízión belüli változásokat. Ezek miatt
a 2005 előtti és utáni magyar adatok összehasonlítása esetén óvatosan,
erre tekintettel kell eljárni.

Természetesen a kódolás minősége is kérdés lehet, történhetnek
adminisztratív hibák, hiányos vagy téves kódolások, nem biztos, hogy
tökéletes a jelentési fegyelem stb., ez különösen igaz, ha a fejlett
világon túli [országokat
is](https://iris.who.int/bitstream/handle/10665/269355/PMC2624200.pdf)
be akarjuk vonni a vizsgálatokba. Több nemzetközi tanulmány vizsgálta a
kódolási minőséget (például az
[autóbalesetekre](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10523810/)
vagy épp az
[esésekre](https://bmcgeriatr.biomedcentral.com/articles/10.1186/s12877-021-02744-3)
vonatkozóan); de talán még érdekesebbek azok a nagyon izgalmas hazai
vizsgálatok, melyek azt [vetették
egybe](https://akjournals.com/view/journals/650/163/37/article-p1481.xml),
hogy a Nemzeti Rákregiszterben szereplő adatok hogyan viszonyulnak a –
KSH-s – haláloki besoroláshoz: egy eredményt kiemelve, 2018-ban 32 586
halálozás volt rosszindulatú dagantként besorolva, ebből 29 970-et
„sikerült megtalálni” a Rákregiszterben.

Mindezek a problémák hatványozottan igazak az emlegetett régi adatokra:
szép-szép, hogy megvan már 1603-ból is London haláloki adatbázisa, de
vajon mire megyünk azzal, hogy hányan [haltak
meg](https://worldhistorycommons.org/londons-bill-mortality)
fényemelkedésben vagy ijedtségben? (Ennél azért jobb a helyzet,
valójában sok betegség beazonosítható, bár az adatminőség nyilván ott is
hihetetlenül rossz mai szemmel nézve. De azért ne becsüljük le: például
a pestis-járványok lefolyása [kiválóan
rekonstruálható](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0008401)
ilyen adatokból is.)

3.  Csak olyan betegségeknél jó, aminél van egyáltalán releváns
    halálozás

Ha valaki a megfázással szeretne foglalkozni, akkor nem sokra megy a
halálozási adatokkal.

4.  A halálozás egybeméri az incidenciát és a gyógyítás hatásfokát

Az előnyök között említettük azt az értelmezést, ami úgy kezdődik, hogy
„ha a halálozási arány állandó” – de mi van ha nem? Ha változik időben
(például mert fejlődik az orvostudomány), akkor sajnos mégsem működik az
előnyöknél elmondott logika, és nem tudunk következtetni a halálozásból
az előfordulásnak még a relatív viszonyaira sem: ha csökken a halálozás,
akkor nem biztos, hogy csökken az előfordulás, lehet, hogy egyszerűen
csak hatékonyabbá vált a gyógyítás. Ha eltér a halálozási arány országok
között (például mert valahol jobb kezelési lehetőségek érhetőek el),
akkor nem vethetőek össze ezzel a logikával a különböző országok: nem
biztos, hogy ahol kevesebb halál van, ott kevesebb – pláne pontosan
arányban kevesebb – a megbetegedés, lehet, hogy csak hatékonyabban
gyógyítanak.

### Az adatok lebontása

Ha a fentieket elfogadva nekiállunk a halálozási adatok használatának,
akkor le kell azokat bontani a három említett szempont szerint: kik,
mikor és hol. Mindháromhoz érdemes kommentárt fűzni.

#### Mikor betegek?

A használt adatbázis éves adatokat tartalmaz. Nagyon is fontos
szempontokat vethet fel egy olyan vizsgálat is, ami használ finomabb
felbontású, például havi vagy heti adatokat (milyen az éven belüli
mintázat, az ún. szezonalitás, van-e hatása annak, hogy munkanapról
van-e szó vagy hétvégéről stb.), de a hosszabb távú elemzésekhez
általában éves adatokat szoktak használni.

#### Hol betegek?

A használt adatbázis alapvetően országokat tartalmaz, ez a legkisebb
vizsgálható egység. Itt is elmondható, hogy érdekes lehet egy olyan
vizsgálat is, ami finomabb felbontást választ, magyar viszonylatban
mondjuk megyei, de ezekről nehezebb adatot szerezni, ráadásul a
definíciós kérdések is élesednek. (Ki tekinthető zalai megyeinek? Ott
született? Ott van a lakcíme? Ott él? Van egyáltalán erről adatunk,
biztos, hogy mindenki ott él, ahol a lakcíme van?)

#### Kik betegek?

A használt adatbázis két szempont szerint bontja le az adatokat: nem és
életkor. (Ez utóbbinál a felbontás némileg függ az országtól, de
jellemzően 5 éves korcsoportokat jelent.) Mindjárt látni fogjuk, hogy
ezek szerepe nagyon fontos, mert egyszerre igaz rájuk, hogy eltérnek
országok között és kihatnak a halálozásra. A probléma inkább az, hogy
további lebontásunk nincsen, nem tudjuk, hogy az elhunytak hogyan
oszlanak meg mondjuk dohányzás, szocioökonómiai státusz vagy elhízás
szerint.

## Miért betegek?

Ezzel elérünk a témának egyfelől a sava-borsához, de másfelől az egyik
legnehezebb részéhez.

„Németországban jóval több X-et esznek mint nálunk, és kevesebb a rákos
halálozás mint nálunk! Egyél X-et a rák megelőzésére!”

„Svédországban sokkal kevesebb az Y légszennyező anyag mint nálunk és
nézd meg, sokkal kevesebb a tüdőbetegség miatti halálozás! Az Y
tüdőbetegséget okoz!”

„Tavaly bevezettek nálunk egy új oltást, és nézd meg idén mennyivel több
az infarktusos halál! Az oltás infarktust okoz!”

Első ránézésre úgy tűnik, hogy ezekkel a mondatokkal semmi baj nincs,
sőt, voltaképp ezért csináljuk az egészet. Hát nem ezt mondtam az
elején? Hogy azért érdekel minket, hogy hol, mikor és ki hal meg, hogy
ebből következtessünk az okozati viszonyokra.

De, ezt mondtam, és tényleg nem kis részt ezért vizsgáljuk az egészet –
csak épp ennél jóval ügyesebben kell vizsgálódni.

A probléma ugyanis az, hogy a különböző országok jellemzően ezernyi
tényezőben térnek el egymástól, nem *csak* abban, amit a mondat kiemelt.
Németország nem *csak* abban tér el tőlünk, hogy ott mit esznek
(valójában még ezen az egyen *belül* is eltér ezer dologban, nem csak
egy ételben), hanem abban is, hogy milyen az egészségügyi ellátás,
milyen levegőt szívnak az emberek, milyen az életkoruk, hány dohányzik
közülük, hány elhízott… márpedig ezek mindegyike kihat a halálozásra!
Innentől kezdve, ha találunk is különbséget a rákos halálozások
számában, honnan tudjuk, hogy az a táplálkozás miatt van, és nem a vele
együtt járó egyéb eltérések miatt? Mi van, ha X evésének semmi szerepe,
csak a több X-et fogyasztó Németországban egyúttal kevesebb a dohányos,
és ez a valódi oka a jobb adatoknak? (Mi van, ha az X még ront is, de a
németeknél annyival kevesebb a dohányos, hogy annak a javító hatása
nagyobb, mint X rontó szerepe??)

Ezt a problémát szokták magyarul is használt angol kifejezéssel
[confounding-nak](https://tamas-ferenci.github.io/FerenciTamas_AzOrvosiMegismeresModszertanaEsAzOrvosiKutatasokKritikusErtekelese/)
nevezni. (Szó szerint „összemosódást” jelent, és ez nagyon jó szó: az
táplálkozásbeli eltérés egybe van mosódva egyéb különbségekkel, ezért ha
találunk is eltérést a végeredményben, az nem tudjuk, hogy minek tudható
be.)

Ugyanez a probléma jelentkezik az utolsó idézet kapcsán is, csak nem
térben, hanem időben: a tavalyi és az idei év között ezer egyéb eltérés
is van az oltáson kívül, honnan tudjuk, hogy a tapasztalt különbséget
(az infarktusos halálozások számában) az oltás okozta, és nem az ezernyi
egyéb eltérés? Vagy esetleg ezek valamilyen keveréke?

A probléma az, hogy a *valódi* válasz megtalálásához arra az
információra lenne szükségünk, hogy akkor mi lett *volna* ha *csak*
egyetlen tényező változott *volna* vagy tért el *volna* az országok
között: ekkor tudhatnánk, hogy a tapasztalt különbség a halálozásban
tényleg emiatt van, és nem más eltérés miatt – hiszen nincs más eltérés!
(Pontosabban szólva emiatt, vagy a véletlen ingadozás miatt, de ennek
kezelésére van statisztikai eszköztár.) Voltaképp az a probléma, hogy
nem tudjuk mi lett *volna* ha *csak* egyetlen tényező változott *volna*.
Emiatt lehet, hogy bár az infarktusos halálozások száma lement, de az
oltás mégis infarktust okoz (ha az oltás bevezetése nélkül még többel
ment volna le), vagy fordítva, felment, de az oltás mégis véd az
infarktussal szemben (ha az oltás bevezetése nélkül még többel ment
volna fel). Lehet, hogy ha Németországban kevesebb X-et ennének, akkor
még kevesebb lenne a rákos halálozás – tehát az X kimondottan ártalmas.

TODO: Chile/Svéd TODO: csak életkor van TODO: számpélda

## Az adatok begyűjtése és előkészítése

Az adatok előkészítése két alapvető feladatot jelent: a mortalitási
adatbázis és a lélekszámra vonatkozó adatok előkészítését. Ezt egészíti
ki a BNO-kódok és az országnevek előkészítése.

A feladatot az [R statisztikai
környezet](https://www.youtube.com/c/FerenciTam%C3%A1s/playlists?view=50&sort=dd&shelf_id=2)
alatt oldottam meg, a `data.table` csomagot használva:

``` r
library(data.table)
```

### A mortalitási adatbázis előkészítése

A mortalitási adatok (halálozások számai) az Egészségügyi Világszervezet
(WHO) mortalitási
[adatbázisából](https://www.who.int/data/data-collection-tools/who-mortality-database)
származnak. Ezek tartalmazzák az egyes jelentést adó országok halálozási
számait életkor, nem, év és halálok szerint lebontva. E tényezők szinte
mindegyike igényel kommentárt:

- A halál oka a Betegségek Nemzetközi Osztályozása (BNO, angolul
  International Classification of Diseases, ICD) szerint van megadva. Ez
  egy gigantikus nemzetközi vállalkozás, melyet több mint egy évszázada
  fejlesztenek, és amely azt célozza meg, hogy az összes ismert,
  relevánsan elkülöníthető betegség nemzetközileg egységes, hierarchikus
  osztályozási rendszere legyen. A WHO adatbázisa 1995-től a BNO 10-es
  változatát használja, ez több mint 11 ezer önálló betegséget
  tartalmaz. (Már létezik BNO-11 is, azonban ennek bevezetése még csak
  jelenleg zajlik, eddig még nem e szerintiek a jelentetett adatok.) E
  verzióban a kód formátuma – és ebből fakadóan a hierarchia – a
  következő: a kód első karaktere egy betű, ami a főcsoportot adja meg
  (pl. C: „rosszindulatú daganatok”). A második és harmadik karakter
  szám, ami ezen belül adja meg a betegséget (pl. C92: „myeloid
  leukaemia”); ezek általában valamilyen logikus – pl. anatómiai vagy
  klinikai – sorrendben vannak megadva (pl. C00-tól C14-ig az az ajak, a
  szájüreg és garat rosszindulatú daganatai vannak, C15 a nyelőcső
  rosszindulatú daganata, C16 a gyomoré és így tovább a tápcsatorna
  mentén). A negyedik karakter a betegség további lebontása, például
  típus vagy anatómiai lokalizáció szerint (pl. C925: „akut
  myelomonocytás leukaemia”). A WHO ezt az első 4 karaktert kontrollálja
  központilag, az 5. karaktert az egyes országok szabadon használhatják
  fel saját – akár például finanszírozási, tudományos-statisztikai vagy
  egyéb célt szolgáló – osztályozásukra (pl. Magyarországon C9251: „Akut
  myelomonocytás leukaemia, alacsony-közepes malignitás”). A WHO
  mortalitási adatbázisában ennek megfelelően legfeljebb 4 karaktert
  kell jelenteni, de ezt sem kötelező, van ország, ami csak 3 karaktert,
  vagy akár ennél is jobban összevont listát használ. Ez a `List` nevű
  mezőből olvasható ki (pl. 104-es kód a 4 karakterű jelentés, 103-as a
  3 karakteres jelentés). Én most csak a 104-et, tehát a legfinomabb
  jelentéseket használtam, fontos továbbfejlesztési lehetőség a többi,
  nem 104-es ország/év bekapcsolása. (Ez relatíve könnyű, hiszen a kódok
  eleje ugyanaz.) Nagyobb feladat az 1995 előtti adatok, azaz a 10-es
  verzió előtti BNO-k bekapcsolása, ez azért zűrösebb, mert a különböző
  verziók kódjai között messzemenőkig nincs egy-egy megfeleltetés.
- Az életkori felbontás nem biztos, hogy ugyanaz minden országban,
  illetve évben. A WHO 9 különböző életkori lebontási lehetőséget
  használ, a `Frmat` nevű változó adja meg, hogy egy adott ország egy
  adott évben melyiket alkalmazta. A 0-s a legfinomabb felbontás (0-tól
  4 évig évente, onnantól 5 évente 95-ig, a fölött egyben), az 1-es
  ugyanaz, de már 85 felett egyben, és így tovább, a 8-asban 1-4 után
  már 10 éves csoportok jönnek, és az is csak 65 évig, a fölött egyben,
  míg a 9-es az, ha nincs életkori lebontás. Szerencsére nálam az
  országok/évek szinte kivétel nélkül a 0-s, 1-es, vagy 2-es kategóriába
  tartoztak; mindegyiket felhasználtam. (Ez megfelelő lélekszám adatokat
  igényel, és persze odafigyelést a kódolás során arra, hogy melyik
  ország/év melyik csoportba tartozik.)
- A nem változó az alany születési nemét jelenti, 1 (férfi) vagy 2 (nő)
  értéket vehet fel, ezen kívül a 9-es (ismeretlen) fordul elő, de
  nagyon kis számban, ezeket elhagytam.

Az 1995 utáni (BNO-10 szerint kódolt) adatok 5 darab tömörített fájlban
érhetőek el, ezeket letöltjük, kibontjuk (egy ideiglenes mappába), majd
beolvassuk. Szerencsére a formátumuk állandó, és a `data.table::fread`
pontosan felismeri:

``` r
td <- tempdir()

unzip("./inputdata/morticd10_part1.zip", exdir = td)
unzip("./inputdata/morticd10_part2.zip", exdir = td)
unzip("./inputdata/morticd10_part3.zip", exdir = td)
unzip("./inputdata/morticd10_part4.zip", exdir = td)
unzip("./inputdata/morticd10_part5.zip", exdir = td)

RawData <- rbindlist(lapply(list.files(td, pattern = "Morticd10*", full.names = TRUE), fread))
```

Problémát jelenthetnek az ország-kódok, amelyek egy elég szokatlan,
szerintem egyedül a WHO által használt kódrendszerrel vannak kódolva
(pl. Magyarország kódja 4150). Szerencsére a WHO honlapjáról letölthető
egy olyan táblázat, melyben a szokásosabb kódok is megtalálhatóak e
mellett, így ez lecserélhető valamilyen bevettebb kódra; én most a
háromjegyű ISO kódot fogom a későbbiekben használni az egyértelmű
azonosításhoz:

``` r
CountryCodes <- fread(
  "https://apps.who.int/gho/athena/data/xmart.csv?target=COUNTRY&profile=xmart")
```

Ez majdnem tökéletesen összekapcsolható a korábbi táblával, azaz
használható a kódok ISO-ra történő lecseréléséhez, mindössze két, nagy
jelentőséggel nem bíró területet vesztünk el, mert nincs kódja (1303:
Mayotte, 3283: Occupied Palestinian Territory):

``` r
unique(merge(RawData, CountryCodes[, .(Country = MORT, CountryName = DisplayString, iso3c = ISO,
                                       Region = WHO_REGION_CODE)], by = "Country",
             all.x = TRUE)[is.na(iso3c)]$Country)
```

    ## [1] 1303 3283

``` r
RawData <- merge(RawData, CountryCodes[, .(Country = MORT, CountryName = DisplayString,
                                           iso3c = ISO, Region = WHO_REGION_CODE)],
                 by = "Country")
```

Azért, hogy felesleges adatokat ne tároljunk, muszáj egy kicsit
előrefutni: betöltöm a lélekszám-adatokat is a HMD-ből (részleteket lásd
a következő pontban), hogy csak azokat az országokat őrizzük meg,
amikhez van lélekszám-adat.

Egyedül arra kell vigyázni, hogy a HMD-ben bizonyos országok kódjai, ami
a fájlnév elején jelenik meg, nem az ISO-kód; ezeket – hogy az
ISO-kódokat ne kelljen bántani – a fájlok átnevezésével oldjuk meg:

``` r
unzip("./inputdata/population.zip", exdir = td)

list.files(paste0(td, "/Population"))
```

    ##  [1] "AUS.Population.txt"     "AUT.Population.txt"     "BEL.Population.txt"    
    ##  [4] "BGR.Population.txt"     "BLR.Population.txt"     "CAN.Population.txt"    
    ##  [7] "CHE.Population.txt"     "CHL.Population.txt"     "CZE.Population.txt"    
    ## [10] "DEUTE.Population.txt"   "DEUTNP.Population.txt"  "DEUTW.Population.txt"  
    ## [13] "DNK.Population.txt"     "ESP.Population.txt"     "EST.Population.txt"    
    ## [16] "FIN.Population.txt"     "FRACNP.Population.txt"  "FRATNP.Population.txt" 
    ## [19] "GBR_NIR.Population.txt" "GBR_NP.Population.txt"  "GBR_SCO.Population.txt"
    ## [22] "GBRCENW.Population.txt" "GBRTENW.Population.txt" "GRC.Population.txt"    
    ## [25] "HKG.Population.txt"     "HRV.Population.txt"     "HUN.Population.txt"    
    ## [28] "IRL.Population.txt"     "ISL.Population.txt"     "ISR.Population.txt"    
    ## [31] "ITA.Population.txt"     "JPN.Population.txt"     "KOR.Population.txt"    
    ## [34] "LTU.Population.txt"     "LUX.Population.txt"     "LVA.Population.txt"    
    ## [37] "NLD.Population.txt"     "NOR.Population.txt"     "NZL_MA.Population.txt" 
    ## [40] "NZL_NM.Population.txt"  "NZL_NP.Population.txt"  "POL.Population.txt"    
    ## [43] "PRT.Population.txt"     "RUS.Population.txt"     "SVK.Population.txt"    
    ## [46] "SVN.Population.txt"     "SWE.Population.txt"     "TWN.Population.txt"    
    ## [49] "UKR.Population.txt"     "USA.Population.txt"

``` r
file.rename(paste0(td, "/Population/DEUTNP.Population.txt"),
            paste0(td, "/Population/DEU.Population.txt")) # a kód 4085, egész Németország
```

    ## [1] TRUE

``` r
file.rename(paste0(td, "/Population/FRATNP.Population.txt"),
            paste0(td, "/Population/FRA.Population.txt"))
```

    ## [1] TRUE

``` r
file.rename(paste0(td, "/Population/GBR_NP.Population.txt"),
            paste0(td, "/Population/GBR.Population.txt"))
```

    ## [1] TRUE

``` r
file.rename(paste0(td, "/Population/GBRTENW.Population.txt"),
            paste0(td, "/Population/X10.Population.txt"))
```

    ## [1] TRUE

``` r
file.rename(paste0(td, "/Population/GBR_NIR.Population.txt"),
            paste0(td, "/Population/X11.Population.txt"))
```

    ## [1] TRUE

``` r
file.rename(paste0(td, "/Population/GBR_SCO.Population.txt"),
            paste0(td, "/Population/X12.Population.txt"))
```

    ## [1] TRUE

``` r
file.rename(paste0(td, "/Population/NZL_NP.Population.txt"),
            paste0(td, "/Population/NZL.Population.txt"))
```

    ## [1] TRUE

``` r
PopList <- sapply(strsplit(list.files(paste0(td, "/Population")), ".", fixed = TRUE), `[`, 1)
```

Ez alapján leszűkítjük a mortalitási adatokat a releváns országokra:

``` r
RawData <- RawData[iso3c %in% PopList]
```

Dobjuk ki a nem megfelelő kódokat használó országokat/éveket. A 101 és
UE1 lehet, hogy némi kézi küzdelemmel menthető lenne, de ezzel most nem
foglkozunk:

``` r
RawData <- RawData[!List%in%c("101", "UE1")]
```

A 103 és 10M pláne menthető lenne, most csak az egyszerűség kedvéért
hagyjuk el, mert nem vészesen nagy veszteség:

``` r
RawData[, as.list(prop.table(table(factor(List, levels = unique(RawData$List))))),
        .(CountryName)][order(`104`, decreasing = TRUE)]
```

    ##                                              CountryName       104        103
    ##                                                   <char>     <num>      <num>
    ##  1:                                               Canada 1.0000000 0.00000000
    ##  2:                                                Chile 1.0000000 0.00000000
    ##  3:                             United States of America 1.0000000 0.00000000
    ##  4:       China, Hong Kong Special Administrative Region 1.0000000 0.00000000
    ##  5:                                               Israel 1.0000000 0.00000000
    ##  6:                                                Japan 1.0000000 0.00000000
    ##  7:                                              Austria 1.0000000 0.00000000
    ##  8:                                              Belarus 1.0000000 0.00000000
    ##  9:                                              Croatia 1.0000000 0.00000000
    ## 10:                                              Czechia 1.0000000 0.00000000
    ## 11:                                              Denmark 1.0000000 0.00000000
    ## 12:                                               France 1.0000000 0.00000000
    ## 13:                                              Germany 1.0000000 0.00000000
    ## 14:                                               Greece 1.0000000 0.00000000
    ## 15:                                              Hungary 1.0000000 0.00000000
    ## 16:                                                Italy 1.0000000 0.00000000
    ## 17:                                           Luxembourg 1.0000000 0.00000000
    ## 18:                                               Norway 1.0000000 0.00000000
    ## 19:                                               Poland 1.0000000 0.00000000
    ## 20:                                             Portugal 1.0000000 0.00000000
    ## 21:                                                Spain 1.0000000 0.00000000
    ## 22:                                          Switzerland 1.0000000 0.00000000
    ## 23: United Kingdom of Great Britain and Northern Ireland 1.0000000 0.00000000
    ## 24:                    United Kingdom, England and Wales 1.0000000 0.00000000
    ## 25:                     United Kingdom, Northern Ireland 1.0000000 0.00000000
    ## 26:                             United Kingdom, Scotland 1.0000000 0.00000000
    ## 27:                                            Australia 1.0000000 0.00000000
    ## 28:                                          New Zealand 1.0000000 0.00000000
    ## 29:                                    Republic of Korea 0.9699473 0.03005271
    ## 30:                                            Lithuania 0.9592007 0.04079930
    ## 31:                                              Belgium 0.9587635 0.04123653
    ## 32:                                               Sweden 0.9227444 0.00000000
    ## 33:                         Netherlands (Kingdom of the) 0.8470865 0.00000000
    ## 34:                                              Ireland 0.8322936 0.16770637
    ## 35:                                              Iceland 0.7589324 0.24106762
    ## 36:                                             Bulgaria 0.7055724 0.29442756
    ## 37:                                               Latvia 0.6995301 0.30046989
    ## 38:                                             Slovakia 0.5994131 0.40058689
    ## 39:                                              Estonia 0.5931944 0.40680562
    ## 40:                                              Finland 0.0000000 1.00000000
    ## 41:                                             Slovenia 0.0000000 1.00000000
    ##                                              CountryName       104        103
    ##            10M
    ##          <num>
    ##  1: 0.00000000
    ##  2: 0.00000000
    ##  3: 0.00000000
    ##  4: 0.00000000
    ##  5: 0.00000000
    ##  6: 0.00000000
    ##  7: 0.00000000
    ##  8: 0.00000000
    ##  9: 0.00000000
    ## 10: 0.00000000
    ## 11: 0.00000000
    ## 12: 0.00000000
    ## 13: 0.00000000
    ## 14: 0.00000000
    ## 15: 0.00000000
    ## 16: 0.00000000
    ## 17: 0.00000000
    ## 18: 0.00000000
    ## 19: 0.00000000
    ## 20: 0.00000000
    ## 21: 0.00000000
    ## 22: 0.00000000
    ## 23: 0.00000000
    ## 24: 0.00000000
    ## 25: 0.00000000
    ## 26: 0.00000000
    ## 27: 0.00000000
    ## 28: 0.00000000
    ## 29: 0.00000000
    ## 30: 0.00000000
    ## 31: 0.00000000
    ## 32: 0.07725564
    ## 33: 0.15291345
    ## 34: 0.00000000
    ## 35: 0.00000000
    ## 36: 0.00000000
    ## 37: 0.00000000
    ## 38: 0.00000000
    ## 39: 0.00000000
    ## 40: 0.00000000
    ## 41: 0.00000000
    ##            10M

Úgyhogy hagyjuk el ezeket is:

``` r
RawData <- RawData[!List%in%c("103", "10M")]
```

Dobjuk ki az életkori bontás nélküli országokat/éveket (a többit nem,
azokat megmentjük):

``` r
RawData <- RawData[Frmat != 9]
```

Van összesen 50313 életkorhoz nem rendelt halálozás, de ezek aránya
egyetlen országnál sem éri el még az 1 ezreléket sem:

``` r
RawData[, .(sum(Deaths26)/sum(Deaths1)*1000), .(CountryName)][order(V1)]
```

    ##                                              CountryName           V1
    ##                                                   <char>        <num>
    ##  1:                                              Austria 0.0000000000
    ##  2:                                             Bulgaria 0.0000000000
    ##  3:                                              Czechia 0.0000000000
    ##  4:                                              Denmark 0.0000000000
    ##  5:                                               France 0.0000000000
    ##  6:                                              Germany 0.0000000000
    ##  7:                                              Iceland 0.0000000000
    ##  8:                                              Ireland 0.0000000000
    ##  9:                                           Luxembourg 0.0000000000
    ## 10:                         Netherlands (Kingdom of the) 0.0000000000
    ## 11:                                               Norway 0.0000000000
    ## 12:                                               Poland 0.0000000000
    ## 13:                                             Slovakia 0.0000000000
    ## 14:                                                Spain 0.0000000000
    ## 15:                                          Switzerland 0.0000000000
    ## 16:                    United Kingdom, England and Wales 0.0000000000
    ## 17:                     United Kingdom, Northern Ireland 0.0000000000
    ## 18: United Kingdom of Great Britain and Northern Ireland 0.0005075638
    ## 19:                                              Belgium 0.0035712978
    ## 20:                             United Kingdom, Scotland 0.0063881946
    ## 21:                                               Canada 0.0083650637
    ## 22:                                                Chile 0.0088247085
    ## 23:                                               Sweden 0.0167316109
    ## 24:                                            Lithuania 0.0259116227
    ## 25:                                               Israel 0.0486159150
    ## 26:                                                Italy 0.0496806895
    ## 27:                                               Latvia 0.0500927938
    ## 28:                             United States of America 0.0806172986
    ## 29:                                            Australia 0.0826013309
    ## 30:                                              Hungary 0.0894482040
    ## 31:                                              Belarus 0.0916261984
    ## 32:                                               Greece 0.1040738480
    ## 33:                                    Republic of Korea 0.1376767168
    ## 34:                                             Portugal 0.1486109060
    ## 35:                                              Estonia 0.1538645650
    ## 36:                                              Croatia 0.2548436261
    ## 37:                                          New Zealand 0.4215681528
    ## 38:                                                Japan 0.5290881196
    ## 39:       China, Hong Kong Special Administrative Region 0.8052752791
    ##                                              CountryName           V1

Ennek megfelelően ezeket is el fogjuk majd hagyni (később, amikor majd
long formátumra váltunk).

Van 819 nemhez nem rendelt halálozás, ezeknek pláne kicsi a száma,
egyszerűen elhagyjuk:

``` r
RawData <- RawData[Sex != 9]
```

A következő feladat a 3 különböző életkori felbontás kezelése.

Először is, a `Deaths23` tartalma problémás, ugyanis függ a formátumtól:
0-s formátumban azt jelenti, hogy „85-89”, viszont 1-es és 2-es
formátumban azt, hogy „85 vagy afölött”. Azért, hogy ettől
megszabaduljunk, bevezetünk egy új változót, mely nevében is utal arra,
hogy összevont életkori kategória, ebbe belementjük az 1-est és a 2-est,
és az eredeti `Deaths23`-at ezeknél `NA`-ra állítjuk, így a `Deaths23`
jelentése tiszta lesz. Az újonnan bevezett változót meg természetesen a
0-snál állítjuk `NA`-ra:

``` r
RawData$Deaths232425 <- ifelse(RawData$Frmat == 0, NA, RawData$Deaths23)
RawData$Deaths23 <- ifelse(RawData$Frmat == 0, RawData$Deaths23, NA)
```

Ugyanez a helyzet a `Deaths3`-mal, ami a 2-es formátumnál jelent mást:

``` r
RawData$Deaths3 <- ifelse(RawData$Frmat == 2, NA, RawData$Deaths3)
```

Itt viszont az összevont kategóriát az összesnél elmentjük, de ennek
teljesen más oka van (a referencia-populáció is csak az összevont
életkori kategóriát fogja tartalmazni):

``` r
RawData$Deaths3456 <- ifelse(RawData$Frmat == 2, RawData$Deaths3,
                             RawData$Deaths3 + RawData$Deaths4 + RawData$Deaths5 +
                               RawData$Deaths6)
```

Ezután átalakítjuk az adatokat a későbbi feldolgozást lényegesen
megkönnyítő long formátumra, a WHO által megadott wide formátumról. Itt
hagyjuk el a korábban már említett `Deaths26`-ot (egyszerűen azáltal,
hogy nem választjuk ki), illetve hasonlóan a `Deaths1`-et, ami az összes
halálozás, de erre nincs szükség, mert redundáns, ezt úgyis elő tudjuk
állítani később:

``` r
RawData <- melt(RawData[, c("iso3c", "Year", "Cause", "Sex", "Frmat", paste0("Deaths", 2:25),
                            "Deaths3456", "Deaths232425")],
                id.vars = c("iso3c", "Year", "Cause", "Sex", "Frmat"), variable.name = "Age")
```

Ahol `NA` van az életkornál, az a fenti manőverjeink miatt van: ez jelzi
azt, hogy az adott életkori bontásnál a kérdéses kategória nem
jelentett. Long formátumban viszont egyszerűen elhagyhatjuk ezeket:

``` r
RawData <- RawData[!is.na(value)]
```

Szintén hagyjuk el az „összes halálozás”-t jelző, teljesen irreguláris
„AAA” kódot (különösen, mert szintén redundáns, úgyis bármikor elő
tudjuk állítani, ha kellene):

``` r
RawData <- RawData[Cause != "AAA"]
```

A WHO adatbázisában a BNO-kódok érdekes módon annak ellenére sem mind 4
jegyűek, hogy már leszűkítettük magunkat csak a 104-es formátumra.
Viszont ahogy nézegettem, ennek egyetlen oka van, ez pedig az, hogy az
utolsó 0-t néha elhagyták. (Elsőre ráadásul úgy tűnhet, hogy ezt
teljesen kiszámíthatatlanul, össze-vissza tették, például C33 van, C330
nincs, de C340 van és C34 nincs. A magyarázat az, hogy hol van
alábontás: ahol ilyen létezik, mint a C34, ott kiírták a 0-t is, ahol
viszont nincs, mint a C33, ott nem.) Akárhogy is, ez nekünk később nem
lesz szerencsés, úgy egészítsük ki a kódokat az esetlegesen hiányzó
0-kkal, hogy mindenhol 4 jegyű legyen:

``` r
RawData$Cause <- stringi::stri_pad_right(RawData$Cause, 4, 0)
```

Ezután már csak technikai apróság van hátra: a kategoriális változókat
alakítsuk tényleg faktorrá (ez a nem esetén fontosabb, mert ott így
címkét is adhatunk, de a többinél is érdemes, mert jelentősen csökkenti
a tárigényt, mivel nem szövegeket kell tárolni). Ugyanez okból állítsunk
be egy kulcsot is:

``` r
RawData$Sex <- factor(RawData$Sex, levels = 1:2, labels = c("Férfi", "Nő"))
RawData$iso3c <- as.factor(RawData$iso3c)
RawData$Cause <- as.factor(RawData$Cause)
RawData$Frmat <- as.factor(RawData$Frmat)

setkey(RawData, "Cause")
```

Ezzel végeztünk, ezután már kimenthetjük a végleges adatbázist:

``` r
saveRDS(RawData, "./procdata/WHO-MDB.rds")
```

Mentsük ki `feather` formátumban is, a weboldal később ezt fogja
használni (mert gyorsabb beolvasni):

``` r
arrow::write_feather(RawData, "./procdata/WHO-MDB.feather")
```

A WHO adatbázisának megvan az a problémája, hogy a 0-s adatok – az
életkor kivételével – nem 0-val szerepelnek, hanem egyszerűen
hiányoznak. (Magyarán, ha például egy BNO-ból egyáltalán nem volt adott
országban és adott évben halálozás, akkor nem 0-val fog szerepelni,
hanem egyszerűen nem lesz benne a BNO a kérdéses országban és évnél. Az
életkor azért kivétel, mert az külön oszlopokban van az eredeti
táblában, így ott a 0-k is mindenképp ki vannak írva.) Ennek a későbbi
kezeléséhez szükségünk lesz országonként és évenként az összes nem és
életkor kombinációjára:

``` r
RawDataAll <- unique(RawData[, .(iso3c, Year, Sex, Age, Frmat)])
saveRDS(RawDataAll, "./procdata/RawDataAll.rds")
```

### Az országnevek és -azonosítók előkészítése

A későbbiekhez jól fog jönni egy lista az országokról (kóddal és
névvel), de hogy feleslegesek ne legyenek köztük, ezt is szűkítsük le
azokra, amik előfordulnak az adatbázisban. A `countries` csomaggal
magyar fordítást is kérünk; ez három kivétellel (ezeket a kódokat nem
ismeri) mindenhol működik. Ezt a hármat mentsük el kézzel külön:

``` r
CountryCodes <- CountryCodes[MORT %in% unique(RawData$Country) & !ISO%in%c("X10", "X11", "X12"),
                             .(iso3c = ISO, Country = countries::country_name(DisplayString,
                                                                              to = "name_hu"))]
```

    ## All values in argument - x - are NA or NULL

``` r
CountryCodes <- rbind(CountryCodes,
                      data.table(iso3c = c("X10", "X11", "X12"),
                                 Country = c("Anglia és Wales", "Észak-Írország", "Skócia")))
```

Ezután kimenthetjük az adatokat:

``` r
saveRDS(setNames(CountryCodes$iso3c, CountryCodes$Country), "./procdata/CountryCodes.rds")
```

### A BNO adatok előkészítése

A BNO-k tulajdonképpen jelen állapotukban is használhatóak lennének,
csak két baj van: nincsenek hozzájuk – pláne magyar – neveink, valamint
nem tudjuk szemantikusan kezelni őket (pl. a főcsoportra, vagy adott
betegségre szűrni), hiszen jelenleg egyetlen sztringként egyben kezeljük
a kódokat. Oldjuk ezeket meg!

Elsőként beolvassuk a hivatalos magyar BNO-törzset a [NEAK
honlapjáról](https://www.neak.gov.hu/felso_menu/szakmai_oldalak/gyogyito_megeleozo_ellatas/adatbazisok/torzsek/torzsek),
figyelve a jó kódolásra, ami nem nyilvánvaló kérdés:

``` r
ICDData <- data.table(foreign::read.dbf("./inputdata/BNOTORZS.DBF", as.is = TRUE))
ICDData$NEV <- stringi::stri_encode(ICDData$NEV, "windows-852", "UTF-8")
```

Ebben vannak már nem érvényes kódok is, szerencsére ezek az `ERV_VEGE`
nevű változó alapján könnyen azonosíthatóak:

``` r
ICDData <- ICDData[ERV_VEGE=="29991231"]
```

Ebben a táblában minden BNO-kód pontosan 5 karakter.

Ahol az 5. karakter 0, ott egyszerűen megoldhatjuk a 4 karakterere
konverziót, mert csak el kell hagyni az utolsó karaktert:

``` r
ICDData[substring(ICDData$KOD10, 5, 5)=="0"]$KOD10 <- substring(
  ICDData[substring(ICDData$KOD10, 5, 5)=="0"]$KOD10, 1, 4)
```

Nagyobb problémát jelentenek a magyar adatbázisban szereplő `H0`
(illetve a fenti levágás nélkül már csak `H`) végű kódok, amik
lényegében azt fejezik ki, hogy ott bármi lehet. Ezt azonban így nem
tudjuk illeszteni a WHO táblájával, ezért jobb híján egyszerűen
kiegészítjük az összes lehetséges értékkel:

``` r
ICDData <- rbind(ICDData[substring(KOD10, 4, 4) != "H"],
                 ICDData[substring(KOD10, 4, 4) == "H", cbind(KOD10 = paste0(substring(KOD10, 1, 3), 0:9), .SD),
                         .(regi = KOD10)][, -"regi"])
```

Nagyon érdekes, de még így sem leszünk teljesen rendben: a következő
kódok szerepelnek a WHO-nál, de a hazai táblában nem. Elképzelésem
sincs, hogy ennek mi lehet az oka, ilyen elvileg nem fordulhatna elő:

``` r
unique(merge(RawData, ICDData[, .(Cause = KOD10, Nev = NEV)], all.x = TRUE)[is.na(Nev)]$Cause)
```

    ##   [1] "A970" "A971" "A972" "A979" "B179" "B334" "B485" "B980" "B981" "C799"
    ##  [11] "C814" "C823" "C824" "C825" "C826" "C846" "C847" "C848" "C849" "C852"
    ##  [21] "C860" "C861" "C862" "C863" "C864" "C865" "C866" "C884" "C903" "C916"
    ##  [31] "C918" "C926" "C928" "C933" "C946" "C964" "C965" "C966" "C968" "D164"
    ##  [41] "D465" "D466" "D474" "D475" "D685" "D686" "D893" "E164" "E883" "G140"
    ##  [51] "G214" "G233" "G835" "G836" "G904" "G905" "G906" "G907" "H549" "I272"
    ##  [61] "I725" "I726" "J090" "J123" "J211" "J987" "K025" "K123" "K227" "K317"
    ##  [71] "K352" "K353" "K358" "K432" "K433" "K434" "K435" "K436" "K437" "K523"
    ##  [81] "K553" "K581" "K582" "K588" "K635" "K640" "K641" "K642" "K643" "K644"
    ##  [91] "K645" "K648" "K649" "K662" "K754" "K834" "L987" "M317" "M726" "M797"
    ## [101] "N181" "N182" "N183" "N184" "N185" "N423" "O142" "O432" "O987" "P916"
    ## [111] "P917" "Q315" "R003" "R263" "R296" "R502" "R508" "R636" "R652" "R653"
    ## [121] "R659" "U049" "U070" "U099" "U109" "U129" "W460" "W462" "W468" "W469"

Ezt kézzel javítjuk:

``` r
ICDData <- rbind(ICDData, data.table(
  KOD10 = unique(merge(RawData, ICDData[, .(Cause = KOD10, Nev = NEV)], all.x = TRUE)[is.na(Nev)]$Cause),
  JEL = NA, NEV = unique(merge(RawData, ICDData[, .(Cause = KOD10, Nev = NEV)], all.x = TRUE)[is.na(Nev)]$Cause),
  NEM = 0, KOR_A = 0, KOR_F = 99, ERV_KEZD = "19950101", ERV_VEGE = "29991231"))
```

A későbbi feldolgozhatóság kedvéért az 1. karaktert és a 2-3. számot
mentsük ki külön:

``` r
ICDData$Kod1 <- substring(ICDData$KOD10, 1, 1)
ICDData$Kod23 <- as.numeric(substring(ICDData$KOD10, 2, 3))
```

Így már definiálhatóak a nagyobb csoportok; én most az [Eurostat
listáját](https://ec.europa.eu/eurostat/cache/metadata/Annexes/hlth_cdeath_sims_an_2.pdf)
használtam:

``` r
ICDGroups <- setNames(as.list(ICDData$KOD10), paste0(ICDData$KOD10, " - ", ICDData$NEV))
ICDGroups <- ICDGroups[ICDGroups %in% RawData$Cause]
ICDGroups <- c(ICDGroups,
               setNames(list(ICDData[Kod1!="Z"&(Kod1!="Y"|Kod23<=89)]$KOD10),
                        "Összes halálok (A00-Y89)"),
               setNames(list(ICDData[Kod1%in%c("A", "B")]$KOD10),
                        "Fertőző és parazitás betegségek (A00-B99)"),
               setNames(list(ICDData[(Kod1=="A"&Kod23>=15&Kod23<=19)|(Kod1=="B"&Kod23==90)]$KOD10),
                        "Gümőkór (A15-A19, B90)"),
               setNames(list(ICDData[Kod1=="B"&Kod23>=20&Kod23<=24]$KOD10),
                        "Humán immunodeficiencia vírus (HIV) betegség (B20-B24)"),
               setNames(list(ICDData[(Kod1=="B"&Kod23>=15&Kod23<=19)|KOD10=="B942"]$KOD10),
                        "Vírusos májgyulladás (B15-B19, B94.2)"),
               setNames(list(ICDData[(Kod1=="A"&(Kod23<=9|Kod23>=20))|
                                       (Kod1=="B"&(Kod23<=9|
                                                     (Kod23>=25&Kod23<=89)|
                                                     (Kod23>=91&Kod23<=93)|
                                                     (Kod23>=95&Kod23<=99)|
                                                     (KOD10%in%c("B940", "B941", "B948", "B949", "B9481"))))]$KOD10),
                        "Egyéb fertőző és parazitás betegségek (A00-A09, A20-B09, B25-B89, B91-B94.1, B94.8-B99)"),
               setNames(list(ICDData[Kod1=="C"|(Kod1=="D"&Kod23<=48)]$KOD10),
                        "Daganatok (C00-D48)"),
               setNames(list(ICDData[Kod1=="C"]$KOD10),
                        "Rosszindulatú daganatok (C00-C97)"),
               setNames(list(ICDData[Kod1=="C"&(Kod23>=0&Kod23<=14)]$KOD10),
                        "Az ajak, a szájüreg és garat rosszindulatú daganatai (C00-C14)"),
               setNames(list(ICDData[Kod1=="C"&Kod23==15]$KOD10),
                        "A nyelőcső rosszindulatú daganata (C15)"),
               setNames(list(ICDData[Kod1=="C"&Kod23==16]$KOD10),
                        "A gyomor rosszindulatú daganata (C16)"),
               setNames(list(ICDData[Kod1=="C"&Kod23>=18&Kod23<=21]$KOD10),
                        "A vastagbél, végbél és a végbélnyílás rosszindulatú daganatai (C18-C21)"),
               setNames(list(ICDData[Kod1=="C"&Kod23==22]$KOD10),
                        "A máj és intrahepaticus epeutak rosszindulatú daganata (C22)"),
               setNames(list(ICDData[Kod1=="C"&Kod23==25]$KOD10),
                        "A hasnyálmirigy rosszindulatú daganata (C25)"),
               setNames(list(ICDData[Kod1=="C"&Kod23==32]$KOD10),
                        "A gége rosszindulatú daganata (C32)"),
               setNames(list(ICDData[Kod1=="C"&Kod23>=33&Kod23<=34]$KOD10),
                        "A légcső, a hörgő és a tüdő rosszindulatú daganatai (C33-C34)"),
               setNames(list(ICDData[Kod1=="C"&Kod23==43]$KOD10),
                        "A bőr rosszindulatú melanomája (C43)"),
               setNames(list(ICDData[Kod1=="C"&Kod23==50]$KOD10),
                        "Az emlő rosszindulatú daganata (C50)"),
               setNames(list(ICDData[Kod1=="C"&Kod23==53]$KOD10),
                        "A méhnyak rosszindulatú daganata (C53)"),
               setNames(list(ICDData[Kod1=="C"&Kod23>=54&Kod23<=55]$KOD10),
                        "A méhtest és a méh nem meghatározott részének rosszindulatú daganatai (C54-55)"),
               setNames(list(ICDData[Kod1=="C"&Kod23==56]$KOD10),
                        "A petefészek rosszindulatú daganata (C56)"),
               setNames(list(ICDData[Kod1=="C"&Kod23==61]$KOD10),
                        "A prostata rosszindulatú daganata (C61)"),
               setNames(list(ICDData[Kod1=="C"&Kod23==64]$KOD10),
                        "A vese rosszindulatú daganata, kivéve a vesemedencét (C64)"),
               setNames(list(ICDData[Kod1=="C"&Kod23==67]$KOD10),
                        "A húgyhólyag rosszindulatú daganata (C67)"),
               setNames(list(ICDData[Kod1=="C"&Kod23>=70&Kod23<=72]$KOD10),
                        "Az agyburkok, az agy, a gerincvelő, az agyidegek és a központi idegrendszer egyéb részeinek rosszindulatú daganatai (C70-C72)"),
               setNames(list(ICDData[Kod1=="C"&Kod23==73]$KOD10),
                        "A pajzsmirigy rosszindulatú daganata (C73)"),
               setNames(list(ICDData[Kod1=="C"&Kod23>=81&Kod23<=86]$KOD10),
                        "Hodgkin kór és lymphomák (C81-C86)"),
               setNames(list(ICDData[Kod1=="C"&Kod23>=91&Kod23<=95]$KOD10),
                        "Leukémia (C91-C95)"),
               setNames(list(ICDData[Kod1=="C"&(Kod23==88|Kod23==90|Kod23==96)]$KOD10),
                        "A nyirok-, a vérképző- és kapcsolódó szövetek egyéb rosszindulatú daganatai (C88, C90, C96)"),
               setNames(list(ICDData[Kod1=="C"&(Kod23==17|(Kod23>=23&Kod23<=24)|(Kod23>=26&Kod23<=31)|(Kod23>=37&Kod23<=41)|(Kod23>=44&Kod23<=49)|(Kod23>=51&Kod23<=52)|(Kod23>=57&Kod23<=60)|(Kod23>=62&Kod23<=63)|(Kod23>=65&Kod23<=66)|(Kod23>=68&Kod23<=69)|(Kod23>=74&Kod23<=80)|Kod23==97)]$KOD10),
                        "Egyéb rosszindulatú daganatok (C17, C23-C24, C26-C31, C37-C41, C44-C49, C51-C52, C57-C60, C62-C63, C65-C66, C68-C69, C74-C80, C97)"),
               setNames(list(ICDData[Kod1=="D"&Kod23>=0&Kod23<=48]$KOD10),
                        "In situ, jóindulatú, vagy bizonytalan vagy ismeretlen viselkedésű daganatok (D00-D48)"),
               setNames(list(ICDData[Kod1=="D"&Kod23>=50&Kod23<=89]$KOD10),
                        "A vér és a vérképző szervek betegségei és az immunrendszert érintő egyéb rendellenességek (D50-D89)"),
               setNames(list(ICDData[Kod1=="E"&Kod23>=0&Kod23<=89]$KOD10),
                        "Endokrin, táplálkozási és anyagcsere betegségek (E00-E89)"),
               setNames(list(ICDData[Kod1=="E"&Kod23>=10&Kod23<=14]$KOD10),
                        "Cukorbetegség (E10-E14)"),
               setNames(list(ICDData[Kod1=="E"&((Kod23>=0&Kod23<=7)|(Kod23>=15&Kod23<=89))]$KOD10),
                        "Egyéb endokrin, táplálkozási és anyagcsere betegségek (E00-E07, E15-E89)"),
               setNames(list(ICDData[Kod1=="F"&Kod23>=1&Kod23<=99]$KOD10),
                        "Mentális- és viselkedészavarok (F01-F99)"),
               setNames(list(ICDData[Kod1=="F"&(Kod23==1|Kod23==3)]$KOD10),
                        "Dementia (F01, F03)"),
               setNames(list(ICDData[Kod1=="F"&Kod23==10]$KOD10),
                        "Alkohol okozta mentális- és viselkedészavarok (F10)"),
               setNames(list(ICDData[Kod1=="F"&((Kod23>=11&Kod23<=16)|(Kod23>=18&Kod23<=19))]$KOD10),
                        "Drog és pszichoaktív anyagok használata által okozott mentális- és viselkedészavarok (F11-F16, F18-F19)"),
               setNames(list(ICDData[Kod1=="F"&((Kod23>=4&Kod23<=9)|(Kod23==17)|(Kod23>=20&Kod23<=99))]$KOD10),
                        "Egyéb mentális- és viselkedészavarok (F04-F09, F17, F20-F99)"),
               setNames(list(ICDData[Kod1=="G"|Kod1=="H"]$KOD10),
                        "Az idegrendszer és az érzékszervek betegségei (G00-H95)"),
               setNames(list(ICDData[Kod1=="G"&Kod23==20]$KOD10),
                        "Parkinson-kór (G20)"),
               setNames(list(ICDData[Kod1=="G"&Kod23==30]$KOD10),
                        "Alzheimer-kór (G30)"),
               setNames(list(ICDData[(Kod1=="G"&((Kod23>=0&Kod23<=12)|(Kod23==14)|(Kod23>=21&Kod23<=25)|(Kod23>=31)))|Kod1=="H"]$KOD10),
                        "Az idegrendszer és az érzékszervek egyéb betegségei (G00-G12, G14, G21-G25, G31-H95)"),
               setNames(list(ICDData[Kod1=="I"&Kod23>=0&Kod23<=99]$KOD10),
                        "A keringési rendszer betegségei (I00-I99)"),
               setNames(list(ICDData[Kod1=="I"&Kod23>=20&Kod23<=25]$KOD10),
                        "Ischaemiás szívbetegségek (I20-I25)"),
               setNames(list(ICDData[Kod1=="I"&Kod23>=21&Kod23<=22]$KOD10),
                        "Heveny szívizomelhalás és ismétlődő szívizomelhalás (I21-I22)"),
               setNames(list(ICDData[Kod1=="I"&((Kod23==20)|(Kod23>=23&Kod23<=25))]$KOD10),
                        "Egyéb ischaemiás szívbetegségek (I20, I23-I25)"),
               setNames(list(ICDData[Kod1=="I"&Kod23>=30&Kod23<=51]$KOD10),
                        "A szívbetegség egyéb formái (I30-I51)"),
               setNames(list(ICDData[Kod1=="I"&Kod23>=60&Kod23<=69]$KOD10),
                        "Cerebrovaszkuláris betegségek (I60-I69)"),
               setNames(list(ICDData[Kod1=="I"&((Kod23>=0&Kod23<=15)|(Kod23>=26&Kod23<=28)|(Kod23>=70&Kod23<=99))]$KOD10),
                        "A keringési rendszer egyéb betegségei (I00-I15, I26-I28, I70-I99)"),    
               setNames(list(ICDData[Kod1=="J"&Kod23>=0&Kod23<=99]$KOD10),
                        "A légzőrendszer betegségei (J00-J99)"),
               setNames(list(ICDData[Kod1=="J"&Kod23>=9&Kod23<=11]$KOD10),
                        "Influenza (J09-J11)"),
               setNames(list(ICDData[Kod1=="J"&Kod23>=12&Kod23<=18]$KOD10),
                        "Tüdőgyulladás (J12-J18)"),
               setNames(list(ICDData[Kod1=="J"&Kod23>=40&Kod23<=47]$KOD10),
                        "Idült alsó légúti betegségek (J40-J47)"),
               setNames(list(ICDData[Kod1=="J"&Kod23>=45&Kod23<=46]$KOD10),
                        "Asztma (J45-J46)"),
               setNames(list(ICDData[Kod1=="J"&((Kod23>=40&Kod23<=44)|(Kod23==47))]$KOD10),
                        "Egyéb idült alsó légúti megbetegedések (J40-J44, J47)"),
               setNames(list(ICDData[Kod1=="J"&((Kod23>=0&Kod23<=6)|(Kod23>=20&Kod23<=39)|(Kod23>=60&Kod23<=99))]$KOD10),
                        "A légzőrendszer egyéb betegségei (J00-J06, J20-J39, J60-J99)"),
               setNames(list(ICDData[Kod1=="K"&Kod23>=0&Kod23<=92]$KOD10),
                        "Az emésztőrendszer betegségei (K00-K92)"),
               setNames(list(ICDData[Kod1=="K"&Kod23>=25&Kod23<=28]$KOD10),
                        "Gyomor-, nyombél-, pepticus- és gastrojejunalis fekély (K25-K28)"),
               setNames(list(ICDData[Kod1=="K"&((Kod23==70)|(Kod23>=73&Kod23<=74))]$KOD10),
                        "Idült májgyulladás, májfibrózis és májzsugorodás, valamint alkoholos májbetegség (K70, K73-K74)"),
               setNames(list(ICDData[Kod1=="K"&((Kod23>=0&Kod23<=22)|(Kod23>=29&Kod23<=66)|(Kod23>=71&Kod23<=72)|(Kod23>=75&Kod23<=92))]$KOD10),
                        "Az emésztőrendszer egyéb betegségei (K00-K22, K29-K66, K71-K72, K75-K92)"),
               setNames(list(ICDData[Kod1=="L"&Kod23>=0&Kod23<=99]$KOD10),
                        "A bőr és a bőralatti szövet betegségei (L00-L99)"),
               setNames(list(ICDData[Kod1=="M"&Kod23>=0&Kod23<=99]$KOD10),
                        "A csont-izomrendszer és kötőszövet betegségei (M00-M99)"),
               setNames(list(ICDData[Kod1=="M"&((Kod23>=05&Kod23<=06)|(Kod23>=15&Kod23<=19))]$KOD10),
                        "Rheumatoid arthritis és arthrosis (M05-M06, M15-M19)"),
               setNames(list(ICDData[Kod1=="M"&((Kod23>=0&Kod23<=2)|(Kod23>=8&Kod23<=13)|(Kod23>=20&Kod23<=99))]$KOD10),
                        "A csont-izomrendszer és kötőszövet egyéb betegségei (M00-M02, M08-M13, M20-M99)"),
               setNames(list(ICDData[Kod1=="N"&Kod23>=0&Kod23<=99]$KOD10),
                        "Az urogenitális rendszer megbetegedései (N00-N99)"),   
               setNames(list(ICDData[Kod1=="N"&Kod23>=0&Kod23<=29]$KOD10),
                        "Vese és az ureter betegségei (N00-N29)"),
               setNames(list(ICDData[Kod1=="N"&Kod23>=30&Kod23<=99]$KOD10),
                        "Az urogenitális rendszer egyéb betegségei (N30-N99)"),
               setNames(list(ICDData[Kod1=="O"&Kod23>=0&Kod23<=99]$KOD10),
                        "A terhesség, a szülés és a gyermekágy komplikációi (O00-O99)"),
               setNames(list(ICDData[Kod1=="P"&Kod23>=0&Kod23<=96]$KOD10),
                        "A perinatális szakban keletkező bizonyos állapotok (P00-P96)"),
               setNames(list(ICDData[Kod1=="Q"&Kod23>=0&Kod23<=99]$KOD10),
                        "Veleszületett rendellenességek, deformitások és kromoszómaabnormitások (Q00-Q99)"),
               setNames(list(ICDData[Kod1=="R"&Kod23>=0&Kod23<=99]$KOD10),
                        "Máshova nem osztályozott panaszok, tünetek és kóros klinikai és laboratóriumi leletek (R00-R99)"),
               setNames(list(ICDData[Kod1=="R"&Kod23==95]$KOD10),
                        "Hirtelen csecsemőhalál szindróma  (R95)"),
               setNames(list(ICDData[Kod1=="R"&Kod23>=96&Kod23<=99]$KOD10),
                        "Egyéb hirtelen halál ismeretlen okból, halál tanú nélkül, a halálozás rosszul meghatározott és külön megnevezés nélküli okai (R96-R99)"),
               setNames(list(ICDData[Kod1=="R"&Kod23>=0&Kod23<=94]$KOD10),
                        "Egyéb máshova nem osztályozott panaszok, tünetek és kóros klinikai és laboratóriumi leletek (R00-R94)"),
               setNames(list(ICDData[Kod1=="V"|(Kod1=="Y"&Kod23>=0&Kod23<=89)]$KOD10),
                        "A morbiditás és mortalitás külső okai (V00-Y89)"), 
               setNames(list(ICDData[(Kod1=="V")|(Kod1=="X"&Kod23>=0&Kod23<=59)|(Kod1=="Y"&Kod23>=85&Kod23<=86)]$KOD10),
                        "Balesetek (V01-X59, Y85-Y86)"), 
               setNames(list(ICDData[Kod1=="V"|(Kod1=="Y"&Kod23==85)]$KOD10),
                        "Közlekedési balesetek (V01-V99, Y85)"), 
               setNames(list(ICDData[Kod1=="W"&Kod23>=0&Kod23<=19]$KOD10),
                        "Esések (W00-W19)"),
               setNames(list(ICDData[Kod1=="W"&Kod23>=65&Kod23<=74]$KOD10),
                        "Balesetszerű vízbefulladás vagy elmerülés (W65-W74)"),
               setNames(list(ICDData[Kod1=="X"&Kod23>=40&Kod23<=49]$KOD10),
                        "Káros anyagok által okozott balesetszerű mérgezés (X40-X49)"),
               setNames(list(ICDData[(Kod1=="W"&Kod23>=20&Kod23<=64)|(Kod1=="W"&Kod23>=75)|(Kod1=="X"&Kod23<=39)|(Kod1=="X"&Kod23>=50&Kod23<=59)|(Kod1=="Y"&Kod23==86)]$KOD10),
                        "Egyéb balesetek (W20-W64, W75-X39, X50-X59, Y86)"),
               setNames(list(ICDData[(Kod1=="X"&Kod23>=60&Kod23<=84)|(KOD10=="Y870")]$KOD10),
                        "Szándékos önártalom (X60-X84, Y87.0)"),
               setNames(list(ICDData[(Kod1=="X"&Kod23>=85)|(Kod1=="Y"&Kod23<=9)|(KOD10=="Y871")]$KOD10),
                        "Testi sértés (X85-Y09, Y87.1)"),
               setNames(list(ICDData[(Kod1=="Y"&Kod23>=10&Kod23<=34)|(KOD10=="Y872")]$KOD10),
                        "Nem meghatározott szándékú esemény (Y10-Y34, Y87.2)"),
               setNames(list(ICDData[(Kod1=="Y"&Kod23>=35&Kod23<=84)|(Kod1=="Y"&Kod23>=88&Kod23<=89)]$KOD10),
                        "Törvényes beavatkozás és háborús cselekmények, az orvosi ellátás szövődményei, egyéb külső ok (Y35-Y84, Y88-Y89)"))
```

Ezután az adatok kimenthetőek:

``` r
saveRDS(ICDGroups, "./procdata/ICDGroups.rds")
```

### A lélekszám adatok előkészítése

A WHO közöl ilyen táblát is a honlapján, így nagyon kézenfekvő lenne azt
használni, csak az a probléma, hogy a felbontása kisebb néha, mint a
mortalitási adatoké. (Például Magyarországnál 95 éves korig megy a
mortalitási adatok lebontása, de a korfa cask 85-ig.) Hogy ezen ne
veszítsünk információt, a lélekszám adatokat kézzel rakjuk össze.

Az egyik adatforrás a [Human Mortality
Database](https://mortality.org/):

``` r
PopData <- rbindlist(lapply(unique(RawData$iso3c), function(iso)
  cbind(fread(paste0(td, "/Population/", iso, ".Population.txt"), na.strings = "."),
        iso3c = iso)))
PopData$YearSign <- substring(PopData$Year, 5, 5)
PopData$Year <- as.numeric(substring(PopData$Year, 1, 4))

PopData <- PopData[Year >= 1955] # ennél korábbi adat nincs is a WHO HMD-ben

unique(PopData[YearSign != "", .(Year, iso3c)])
```

    ##     Year  iso3c
    ##    <num> <fctr>
    ## 1:  1959    USA
    ## 2:  1973    JPN
    ## 3:  1975    ESP
    ## 4:  1981    ITA
    ## 5:  2010    BEL
    ## 6:  2011    BEL
    ## 7:  2001    POL
    ## 8:  1991    NZL

``` r
plot(`+` ~ `-`, data = dcast(PopData[YearSign!=""], iso3c + Age + Year ~ YearSign, value.var = "Total"))
abline(0, 1)
```

![](README_files/figure-gfm/unnamed-chunk-35-1.png)<!-- -->

``` r
plot(log(`+`) ~ log(`-`), data = dcast(PopData[YearSign!=""], iso3c + Age + Year ~ YearSign, value.var = "Total"))
abline(0, 1)
```

![](README_files/figure-gfm/unnamed-chunk-35-2.png)<!-- -->

``` r
dcast(PopData[YearSign!=""], iso3c + Age + Year ~ YearSign, value.var = "Total")[, .(iso3c, Age, Year, `+`, `-`, `+`/`-`)][order(V6)]
```

    ##       iso3c    Age  Year        +        -        V6
    ##      <fctr> <char> <num>    <num>    <num>     <num>
    ##   1:    ITA    109  1981     1.00     1.13 0.8849558
    ##   2:    ITA    101  1981   239.00   260.32 0.9181008
    ##   3:    ITA    100  1981   440.00   478.79 0.9189833
    ##   4:    ITA    103  1981    63.00    68.47 0.9201110
    ##   5:    ITA    105  1981    15.00    16.26 0.9225092
    ##  ---                                                
    ## 884:    NZL     13  1991 52007.67 50669.98 1.0264000
    ## 885:    ITA    108  1981     0.00     0.00       NaN
    ## 886:    ITA   110+  1981     0.00     0.00       NaN
    ## 887:    JPN    109  1973     0.00     0.00       NaN
    ## 888:    NZL   110+  1991     0.00     0.00       NaN

``` r
dcast(PopData[YearSign!=""], iso3c + Age + Year ~ YearSign, value.var = "Total")[, .(iso3c, Age, Year, `+`, `-`, `+` - `-`)][order(V6)]
```

    ##       iso3c    Age  Year         +         -       V6
    ##      <fctr> <char> <num>     <num>     <num>    <num>
    ##   1:    ITA     80  1981  205346.6  208444.4 -3097.81
    ##   2:    ITA     71  1981  466932.6  470019.2 -3086.68
    ##   3:    ITA     76  1981  309331.8  312399.7 -3067.80
    ##   4:    ITA     69  1981  507773.4  510838.5 -3065.03
    ##   5:    ITA     74  1981  365055.1  368064.3 -3009.15
    ##  ---                                                 
    ## 884:    JPN     14  1973 1583005.5 1560045.7 22959.74
    ## 885:    JPN     10  1973 1591194.9 1568114.1 23080.77
    ## 886:    USA      1  1959 4091864.0 4068719.8 23144.12
    ## 887:    JPN     13  1973 1605882.3 1582589.9 23292.44
    ## 888:    USA      0  1959 4085035.3 4061321.5 23713.86

``` r
# marginális különbség, a mínuszt használjuk

PopData <- PopData[(YearSign == "")|(YearSign == "-")]

PopData <- melt(PopData[, -"YearSign"], id.vars = c("iso3c", "Year", "Age"), variable.name = "Sex",
                variable.factor = FALSE)[Sex != "Total"]

PopData$Sex <- factor(PopData$Sex, levels = c("Male", "Female"), labels = c("Férfi", "Nő"))
PopData[Age == "110+"]$Age <- "110"
PopData$Age <- as.numeric(PopData$Age)
```

A másik az Eurostat, `demo_pjan` tábla:

``` r
PopDataES <- data.table(eurostat::get_eurostat("demo_pjan", use.data.table = TRUE))
```

    ## Table demo_pjan cached at C:\Users\FERENC~1\AppData\Local\Temp\RtmpsViOQl/eurostat/4344de13d27ff70035a78eb8530877eb.rds

``` r
PopDataES$Year <- lubridate::year(PopDataES$TIME_PERIOD)
PopDataES <- PopDataES[Year >= 1955]
PopDataES <- PopDataES[geo != "DE"]
PopDataES[geo == "DE_TOT"]$geo <- "DE" # a halálozási adatok is egész Németországra vonatkoznak
PopDataES <- PopDataES[!geo%in%c("EA19", "EA20", "EEA30_2007", "EEA31", "EFTA", "EU27_2007", 
                                 "EU27_2020", "EU28", "FX", "XK")]
PopDataES$iso3c <- countrycode::countrycode(PopDataES$geo, "eurostat", "iso3c")
PopDataES <- PopDataES[iso3c%in%unique(RawData$iso3c)]
PopDataES <- PopDataES[age != "TOTAL" & sex != "T"]
PopDataES[age == "UNK"&values>0][order(values)]
```

    ##       freq   unit    age    sex    geo TIME_PERIOD values  Year  iso3c
    ##     <char> <char> <char> <char> <char>      <Date>  <num> <num> <char>
    ##  1:      A     NR    UNK      M     HR  2011-01-01      1  2011    HRV
    ##  2:      A     NR    UNK      M     LU  1960-01-01      2  1960    LUX
    ##  3:      A     NR    UNK      F     HR  2010-01-01      3  2010    HRV
    ##  4:      A     NR    UNK      M     HR  2010-01-01      3  2010    HRV
    ##  5:      A     NR    UNK      F     HR  2009-01-01      5  2009    HRV
    ##  6:      A     NR    UNK      F     HR  2008-01-01      7  2008    HRV
    ##  7:      A     NR    UNK      F     HR  2007-01-01      9  2007    HRV
    ##  8:      A     NR    UNK      M     HR  2009-01-01      9  2009    HRV
    ##  9:      A     NR    UNK      F     HR  2006-01-01     12  2006    HRV
    ## 10:      A     NR    UNK      M     EE  1988-01-01     18  1988    EST
    ## 11:      A     NR    UNK      F     HR  2005-01-01     18  2005    HRV
    ## 12:      A     NR    UNK      M     HR  2008-01-01     18  2008    HRV
    ## 13:      A     NR    UNK      F     EE  1988-01-01     23  1988    EST
    ## 14:      A     NR    UNK      F     HR  2004-01-01     23  2004    HRV
    ## 15:      A     NR    UNK      M     HR  2007-01-01     28  2007    HRV
    ## 16:      A     NR    UNK      F     HR  2003-01-01     29  2003    HRV
    ## 17:      A     NR    UNK      M     EE  1987-01-01     30  1987    EST
    ## 18:      A     NR    UNK      F     HR  2002-01-01     33  2002    HRV
    ## 19:      A     NR    UNK      M     EE  1986-01-01     40  1986    EST
    ## 20:      A     NR    UNK      F     EE  1987-01-01     41  1987    EST
    ## 21:      A     NR    UNK      M     HR  2006-01-01     41  2006    HRV
    ## 22:      A     NR    UNK      F     HR  2001-01-01     42  2001    HRV
    ## 23:      A     NR    UNK      M     HR  2005-01-01     49  2005    HRV
    ## 24:      A     NR    UNK      F     EE  1986-01-01     60  1986    EST
    ## 25:      A     NR    UNK      M     HR  2004-01-01     60  2004    HRV
    ## 26:      A     NR    UNK      F     LU  1969-01-01     62  1969    LUX
    ## 27:      A     NR    UNK      M     EE  1985-01-01     62  1985    EST
    ## 28:      A     NR    UNK      M     HR  2003-01-01     68  2003    HRV
    ## 29:      A     NR    UNK      M     EE  1984-01-01     72  1984    EST
    ## 30:      A     NR    UNK      F     EE  1960-01-01     76  1960    EST
    ## 31:      A     NR    UNK      M     HR  2002-01-01     79  2002    HRV
    ## 32:      A     NR    UNK      M     HR  2001-01-01     83  2001    HRV
    ## 33:      A     NR    UNK      M     EE  1960-01-01     85  1960    EST
    ## 34:      A     NR    UNK      M     EE  1983-01-01     87  1983    EST
    ## 35:      A     NR    UNK      F     EE  1985-01-01     87  1985    EST
    ## 36:      A     NR    UNK      M     EE  1982-01-01     93  1982    EST
    ## 37:      A     NR    UNK      F     EE  1984-01-01    108  1984    EST
    ## 38:      A     NR    UNK      M     EE  1981-01-01    117  1981    EST
    ## 39:      A     NR    UNK      F     EE  1961-01-01    127  1961    EST
    ## 40:      A     NR    UNK      M     EE  1980-01-01    127  1980    EST
    ## 41:      A     NR    UNK      F     EE  1983-01-01    129  1983    EST
    ## 42:      A     NR    UNK      M     EE  1979-01-01    133  1979    EST
    ## 43:      A     NR    UNK      F     EE  1982-01-01    141  1982    EST
    ## 44:      A     NR    UNK      M     EE  1961-01-01    155  1961    EST
    ## 45:      A     NR    UNK      F     EE  1981-01-01    164  1981    EST
    ## 46:      A     NR    UNK      F     EE  1962-01-01    176  1962    EST
    ## 47:      A     NR    UNK      F     EE  1980-01-01    183  1980    EST
    ## 48:      A     NR    UNK      M     EE  1978-01-01    187  1978    EST
    ## 49:      A     NR    UNK      F     EE  1979-01-01    201  1979    EST
    ## 50:      A     NR    UNK      F     LU  1968-01-01    208  1968    LUX
    ## 51:      A     NR    UNK      M     EE  1962-01-01    211  1962    EST
    ## 52:      A     NR    UNK      F     EE  1963-01-01    237  1963    EST
    ## 53:      A     NR    UNK      F     EE  1978-01-01    243  1978    EST
    ## 54:      A     NR    UNK      M     EE  1977-01-01    251  1977    EST
    ## 55:      A     NR    UNK      M     EE  1963-01-01    264  1963    EST
    ## 56:      A     NR    UNK      M     LT  1979-01-01    276  1979    LTU
    ## 57:      A     NR    UNK      F     EE  1977-01-01    297  1977    EST
    ## 58:      A     NR    UNK      F     EE  1964-01-01    299  1964    EST
    ## 59:      A     NR    UNK      M     EE  1976-01-01    301  1976    EST
    ## 60:      A     NR    UNK      M     EE  1964-01-01    323  1964    EST
    ## 61:      A     NR    UNK      F     EE  1976-01-01    342  1976    EST
    ## 62:      A     NR    UNK      F     EE  1965-01-01    360  1965    EST
    ## 63:      A     NR    UNK      F     LT  1979-01-01    366  1979    LTU
    ## 64:      A     NR    UNK      M     EE  1975-01-01    369  1975    EST
    ## 65:      A     NR    UNK      M     EE  1965-01-01    382  1965    EST
    ## 66:      A     NR    UNK      F     EE  1975-01-01    393  1975    EST
    ## 67:      A     NR    UNK      F     EE  1966-01-01    421  1966    EST
    ## 68:      A     NR    UNK      M     EE  1974-01-01    426  1974    EST
    ## 69:      A     NR    UNK      M     EE  1966-01-01    434  1966    EST
    ## 70:      A     NR    UNK      F     EE  1974-01-01    445  1974    EST
    ## 71:      A     NR    UNK      F     EE  1967-01-01    479  1967    EST
    ## 72:      A     NR    UNK      M     EE  1967-01-01    484  1967    EST
    ## 73:      A     NR    UNK      M     EE  1973-01-01    484  1973    EST
    ## 74:      A     NR    UNK      F     EE  1973-01-01    496  1973    EST
    ## 75:      A     NR    UNK      M     EE  1972-01-01    535  1972    EST
    ## 76:      A     NR    UNK      M     EE  1968-01-01    540  1968    EST
    ## 77:      A     NR    UNK      F     EE  1968-01-01    541  1968    EST
    ## 78:      A     NR    UNK      F     EE  1972-01-01    542  1972    EST
    ## 79:      A     NR    UNK      M     EE  1969-01-01    596  1969    EST
    ## 80:      A     NR    UNK      M     EE  1971-01-01    598  1971    EST
    ## 81:      A     NR    UNK      F     EE  1969-01-01    599  1969    EST
    ## 82:      A     NR    UNK      F     EE  1971-01-01    607  1971    EST
    ## 83:      A     NR    UNK      M     EE  1970-01-01    649  1970    EST
    ## 84:      A     NR    UNK      F     EE  1970-01-01    654  1970    EST
    ## 85:      A     NR    UNK      M     LT  1970-01-01    848  1970    LTU
    ## 86:      A     NR    UNK      F     LT  1970-01-01    937  1970    LTU
    ##       freq   unit    age    sex    geo TIME_PERIOD values  Year  iso3c

``` r
sum(PopDataES[age == "UNK"]$values) # nem sok, elhagyjuk
```

    ## [1] 19843

``` r
PopDataES <- PopDataES[age != "UNK"]
PopDataES$age <- substring(PopDataES$age, 2)
PopDataES[age == "_LT1"]$age <- "0"
PopDataES$sex <- factor(PopDataES$sex, levels = c("M", "F"), labels = c("Férfi", "Nő"))

temp <- merge(PopData[, .(iso3c, Age = as.character(Age), Sex, Year, PopHMD = value)],
              PopDataES[, .(iso3c, Age = age, Sex = sex, Year, PopES = values)],
              by = c("iso3c", "Year", "Age", "Sex"), all = TRUE)
plot(PopHMD ~ PopES, data = temp[!is.na(PopHMD)&!is.na(PopES)])
```

![](README_files/figure-gfm/unnamed-chunk-36-1.png)<!-- -->

``` r
temp[is.na(PopHMD)&!is.na(PopES)&Age!="_OPEN"][order(Year)]
```

    ##         iso3c  Year    Age    Sex PopHMD  PopES
    ##        <char> <num> <char> <fctr>  <num>  <num>
    ##     1:    DEU  1960      0  Férfi     NA 620605
    ##     2:    DEU  1960      0     Nő     NA 587080
    ##     3:    DEU  1960      1  Férfi     NA 582886
    ##     4:    DEU  1960      1     Nő     NA 551701
    ##     5:    DEU  1960     10  Férfi     NA 520065
    ##    ---                                         
    ## 16592:    SVK  2023     97     Nő     NA    572
    ## 16593:    SVK  2023     98  Férfi     NA    203
    ## 16594:    SVK  2023     98     Nő     NA    378
    ## 16595:    SVK  2023     99  Férfi     NA    155
    ## 16596:    SVK  2023     99     Nő     NA    259

``` r
temp[!is.na(PopHMD)&is.na(PopES)]
```

    ## Key: <iso3c, Year, Age, Sex>
    ##          iso3c  Year    Age    Sex    PopHMD PopES
    ##         <char> <num> <char> <fctr>     <num> <num>
    ##      1:    AUS  1955      0  Férfi 102006.58    NA
    ##      2:    AUS  1955      0     Nő  97756.99    NA
    ##      3:    AUS  1955      1  Férfi 101600.00    NA
    ##      4:    AUS  1955      1     Nő  97647.12    NA
    ##      5:    AUS  1955     10  Férfi  82364.38    NA
    ##     ---                                           
    ## 248207:    X12  2022     97     Nő   1126.16    NA
    ## 248208:    X12  2022     98  Férfi    242.73    NA
    ## 248209:    X12  2022     98     Nő    795.43    NA
    ## 248210:    X12  2022     99  Férfi    147.05    NA
    ## 248211:    X12  2022     99     Nő    538.35    NA

``` r
PopDataES <- PopDataES[iso3c %in% unique(PopData$iso3c)] # szigorúan csak kiegészítjük a HMD-t

PopDataES <- merge(PopDataES, unique(PopData[, .(iso3c, Year, HMD = TRUE)]),
                   by = c("iso3c", "Year"), all.x = TRUE)
PopDataES <- PopDataES[is.na(HMD)]

PopDataES[iso3c=="GRC"&Year==1960]
```

    ## Key: <iso3c, Year>
    ##     iso3c  Year   freq   unit    age    sex    geo TIME_PERIOD values    HMD
    ##    <char> <num> <char> <char> <char> <fctr> <char>      <Date>  <num> <lgcl>
    ## 1:    GRC  1960      A     NR  _OPEN     Nő     EL  1960-01-01  71533     NA
    ## 2:    GRC  1960      A     NR  _OPEN  Férfi     EL  1960-01-01  52991     NA

``` r
PopDataES <- PopDataES[!((iso3c == "GRC")&(Year == 1960))] # nincs rá egyáltalán semmilyen életkori bontás

PopDataES <- PopDataES[!(iso3c == "GRC" & Year>=1961 & Year <= 1978)] # ezt nem lenne kötelező kidobni, később megmenthető,
# most csak azért, hogy mindegyik meglegyen 95 évig

PopDataES <- merge(PopDataES, PopDataES[, .(OPENYear = max(as.numeric(age[age != "_OPEN"]))) , .(iso3c, Year)], by = c("iso3c", "Year"))
PopDataES[age == "_OPEN"]$age <- PopDataES[age == "_OPEN"]$OPENYear + 1
PopDataES$age <- as.numeric(PopDataES$age)
```

Majd egyesítjük őket:

``` r
PopData <- rbind(PopData[, .(iso3c, Year, Age, Sex, Pop = value)],
                 PopDataES[, .(iso3c, Year, Age = age, Sex = sex, Pop = values)])

PopData$Age <- cut(PopData$Age, c(0:5, seq(10, 95, 5), Inf), right = FALSE, labels = paste0("Deaths", 2:25))
PopData <- PopData[, .(Pop = sum(Pop)), .(iso3c, Year, Age, Sex)]

PopData <- rbind(PopData, PopData[Age%in%paste0("Deaths", 3:6), .(Pop = sum(Pop), Age = "Deaths3456") , .(iso3c, Year, Sex)])

PopData <- rbind(
  cbind(PopData, Frmat = 0),
  cbind(rbind(PopData[!Age%in%paste0("Deaths", 23:25)], PopData[Age%in%paste0("Deaths", 23:25), .(Pop = sum(Pop), Age = "Deaths232425") , .(iso3c, Year, Sex)]), Frmat = 1),
  cbind(rbind(PopData[!Age%in%paste0("Deaths", 23:25) & !Age%in%paste0("Deaths", 3:6)],
              PopData[Age%in%paste0("Deaths", 23:25), .(Pop = sum(Pop), Age = "Deaths232425") , .(iso3c, Year, Sex)]), Frmat = 2)
)

PopData$Aggregated <- ifelse(PopData$Frmat == 2, FALSE, PopData$Age == "Deaths3456")
```

Végül a szokásos módon kimentjük:

``` r
PopData$Frmat <- as.factor(PopData$Frmat)
PopData$Age <- as.factor(PopData$Age)

saveRDS(PopData, "./procdata/WHO-MDB-Population.rds")
```

## Az adatok validációja

TODO

## A weboldal

A weboldal [R Shiny](https://shiny.posit.co/) segítségével készült. Ez a
rendszer lehetővé teszi az R webre történő „kiinterfészelését”, azaz egy
olyan weboldal létrehozását, mely fogadja a felhasználótól a bemenetet,
azt átadja az R-nek, lefuttatja, fogadja a számítások eredményét, majd
azt megfelelően megjeleníti az oldalon. Ezzel lényegében hozzáférhetővé
teszi az R erejét bárki számára, minden R ismeret nélkül is, egy jól
kezelhető és az előbbiekből adódóan interaktív formában. (Ráadásul a
weboldal maga is megírható R alatt minden webes tudás nélkül.)

Az oldal forráskódja letölhető innen: app.R.

## Továbbfejlesztési lehetőségek

- [ ] 103-as (és esetleg egyéb) BNO-kódolási rendszerek bekapcsolása.
- [ ] Az 1995 előtti korábbi BNO-k bekapcsolása.
