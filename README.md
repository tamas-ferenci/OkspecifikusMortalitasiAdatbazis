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
    vonatkozóan érhetőek el. A halálozásokból ugyanis minden egyes
    esetet besorolnak halálok szerint és nyilvánosan jelentenek, addig
    egy betegség puszta fellépésére vonatkozó információ begyűjtése
    általában komoly többlet-energia befektetését igényli, hiszen ilyen
    adatot – szemben a halálozással – rutinszerűen nem gyűjtenek a
    népegészségügyi rendszerek. Alapvetően három megoldási lehetőség jön
    szóba ha előfordulásra vonatkozó adatot szeretnénk gyűjteni; hogy
    jobban megértsük az ezzel kapcsolatos nehézségeket, tekintsük át
    ezeket röviden:

    - Az egyik megoldási lehetőség ad hoc vizsgálatok szervezése.
      (Például egy mintavétellel történő felmérés – jó esetben
      véletlenszerűen a populációból, rosszabb esetben ún. kényelmi
      mintaként, például egyetlen, általunk könnyen lekérdezhető kórház
      adatainak feldolgozásával.) Ez kevesebb erőforrást igényel, de
      csak egy pillanatfelvételt ad, és semmiképp nem teljeskörű,
      kényelmi minta esetén pedig erősen kérdéses is az
      általánosíthatósága.
    - A másik lehetőség az ún. adminisztratív/finanszírozási adatok
      felhasználása. Az alapötlet, hogy a kórházak amúgy is jelentenek
      finanszírozási célból adatokat – miért ne használjuk fel ezt
      epidemiológiai célokra is? Csakugyan, ha valaki egészségügyi
      ellátásban részesül, akkor keletkezik róla egy adatsor, amit
      beküldenek a NEAK-ba, benne a személy nemével, életkorával,
      lakhelyével, betegségével, az elvégzett beavatkozással; ebből
      tényleg kiolvasható lehet a megbetegedés fellépése. Ez nagyon
      csábítóan hangzik, hiszen az erőforrás-igénye csekély (amúgy is
      begyűjtött adatokat dolgozunk fel), de mégis teljeskörű és
      folyamatosan frissülő az adatbázis, legalábbis a közfinanszírozott
      ellátásokra vonatkozóan. Bár ez eddig nagyon jól hangzik, a
      módszernek vannak hátrányai is, egyrészt az adatminőség (ezeket a
      jelentéseket a kórházak rutinszerűen meghamisítják, hogy
      „optimalizálják” a finanszírozásukat), másrészt a klinikai adatok
      hiánya (azt tudjuk, hogy valakit megröntgeneztek, de azt nem
      tudjuk, hogy mi volt a röngtenképen, azt tudjuk, hogy az alany
      hány éves, de azt nem tudjuk, hogy dohányzik-e). Ezzel együtt is,
      ma már egyre több ilyen vizsgálat készül; egy példa tisztán
      akadémiai célokat szolgáló ilyen kutatásra a
      [HUNVASCDATA](https://hunvascdata.hu/)-projekt.
    - Végezetül a harmadik lehetőség a betegségregiszterek használata.
      Ez szó szerint véve „a” megoldás a problémára, hiszen a regiszter
      definíció szerint azt jelenti, hogy valamely megbetegedés
      előfordulásáról a teljesség igényével történő gyűjtés. (Tipikusan
      jogszabály írja el a kötelező jelentést az egészségügyi
      ellátóknak.) Ez látszólag az ideális megoldás: teljeskörű,
      folyamatos, validálható adatminőségű, részletgazdag klinikai
      adatokat is tartalmazhat, egyetlen apró problémája van: az, hogy
      hatalmas az erőforrásigénye. Nem csak „forintban” értve, hanem az
      adatszolgáltatói teherre nézve is, hiszen ez azt is jelenti, hogy
      az észlelő orvosoknak a betegek után egy plusz jelentést is ki
      kell tölteniük, és feltölteni a regiszterbe.

    A jogszabály szerint Magyarországon több mint egy tucat regiszter
    kell, hogy [működjön](https://njt.hu/jogszabaly/2018-49-20-5H),
    ezekből gyakorlatilag kettő az aminek értelmezhető, ténylegesen
    teljeskörű, folyamatosan frissülő, kívülről is látható –
    publikációkban megjelenő, weboldalon lekérdezhető – aktivitása van,
    a [Nemzeti Szívinfarktusregiszter](https://nszr.gokvi.hu/ir/fooldal)
    és a [Nemzeti
    Rákregiszter](https://onkol.hu/nemzeti-rakregiszter-es-biostatisztikai-kozpont/).
    Az összes többi regiszterről még én sem tudom, hogy mit csinálnak,
    van ami elvileg működik, de kívülről nézve aligha betöltve a
    funkcióját (a szívelégtelenség regiszter 2021-ben eredményként
    [számolt be](https://mkardio.hu/hirek.aspx?nid=106368) arról, hogy
    2015 óta összesen 1600 beteget bevontak – miközben Magyarországon
    majdnem 10 ezer *halál* történik ebből, *évente*), van, aminek a
    nevére
    [rákeresve](https://www.google.com/search?client=firefox-b-d&q=%22Feln%C5%91tt+Sz%C3%ADvseb%C3%A9szeti+Regiszter%22)
    kizárólag a jogszabály szövegét kapjuk meg találatként…

    Remélem a fentiekkel tudtam érzékeltetni, hogy mi az oka annak, hogy
    előfordulásra vonatkozó adatok csak betegségek egy szűk körére
    érhetőek el, valamint, hogy az sem várható, hogy ez lényegesen
    megváltozzon a közeljövőben.

2.  Ez különösen igaz, ha időben visszafelé megyünk

    Az előbbi állítás végképp igaz, ha szeretnénk múltbeli adatokat is
    vizsgálni; minél messzebb megyünk vissza, annál inkább. A Nemzeti
    Szívinfarktusregiszter 2014 óta működik mint teljeskörű regiszter, a
    Nemzeti Rákregiszter 2000 óta. Nyugati regisztereknél van példa
    nagyobb időtartamra, de összességében véve legjobb esetben is néhány
    évtizedről beszélünk, ami az előfordulás-jellegű adatok
    elérhetőségét illeti. Ehhez képest az angol haláloki adatok 1851-re
    is
    [elérhetőek](http://doc.ukdataservice.ac.uk/doc/3552/mrdoc/pdf/guide.pdf),
    de a londoniakat már 1603-tól (!) minden évben nyomtatásban
    [közlik](https://www.thelancet.com/journals/lancet/article/PIIS0140-6736(20)30725-X/fulltext).

3.  A halálozás sokszor az egyik legfontosabb mutatója egy betegség
    terhének

    Ha nem egyszerűen a betegség előfordulása érdekel minket, hanem a
    betegség jelentette teher, akkor nagyon sok szempont merül fel:
    szenvedés, maradványtünetekkel gyógyulás, munkából kiesés,
    egészségügyi ellátórendszer igénybevétele és így tovább. Ezek közül
    a halálozás azonban kiemelkedik, egyrészt mert egyértelműen
    definiált és egyértelműen mérhető (mi az, hogy „szenvedés” és hogyan
    lehet számszerűen lemérni?), másrészt mert sok esetben ez a
    legfontosabb, legnagyobb relevanciával bíró szempont, a köznapi
    szóhasználatban és népegészségügyi szempontból is.

4.  Ha a halálozási arány állandó, akkor a halálozás az incidenciát is
    jellemzi

    A betegségbe belehaló emberek száma egy szorzat: a megbetegedő
    emberek száma szorozva a halálozási aránnyal. Amennyiben
    feltételezzük, hogy ez utóbbi állandó, akkor a halálozás valójában
    igenis méri az incidenciát is! Igen, a konkrét szám nem fog
    stimmelni (hacsak a halálozási arány nem 100%), de a *relatív
    viszonyok* rendben lesznek: ha kétszer annyi halálozás van, akkor
    tudhatjuk, hogy az előfordulás is kétszeresére nőtt. Amennyiben az
    „állandó” alatt azt értjük, hogy nem változik időben egy országban,
    akkor az adott ország különböző időszaki adatai vethetőek egybe
    ilyen módon, ha pedig különböző országokban is ugyanaz a halálozási
    arány, akkor még a különböző országok adatai is összevethetőek
    (mondhatjuk, hogy ahol kétszer akkorra a halálozás, ott kétszer
    annyi megbetegedés is van).

#### Milyen bajai vannak a halálozási adatoknak?

1.  A haláloki besorolás problémái

    Ez a kérdés a koronavírus-járvány alatt hatalmas publicitást kapott.
    Egy ahhoz kapcsolódó
    [írásomban](https://github.com/tamas-ferenci/ExcessMortEUR)
    részletesen
    [kifejtettem](https://github.com/tamas-ferenci/ExcessMortEUR?tab=readme-ov-file#a-hal%C3%A1loki-statisztik%C3%A1k-probl%C3%A9m%C3%A1i)
    a problémakört, itt szinte szó szerint meg tudom ismételni az akkor
    leírtakat: gond az, hogy a haláloki statisztikákban mindenkit egy,
    és csak egy halálokhoz kell besorolni. (Magán a halottvizsgálati
    bizonyítványon ennél komplexebb haláloki helyzet is feltüntethető,
    de a végső statisztikában ez nem fog látszni, csak egy pontosan
    definiált, ún. előztetési eljárással kiválasztott halálok, amit
    statisztikai közlésre kiválasztott elsődleges haláloknak szoktak
    nevezni.) A probléma az, hogy az embereknek sokszor nem egyetlen
    halálokuk van: elveszítünk egy szívelégtelen, cukorbeteg alanyt
    stroke-ban; ő akkor most mibe halt bele? A szívelégetelenségbe? A
    cukorbetegségbe? A stroke-ba?

    Ritkák a vegytiszta esetek, mégpedig mindkét irányban ritkák: hogy
    egy egyébként makkegészséges alanyt elvisz egy stroke vagy hogy egy
    stroke-os beteg fejére rádől egy kémény az utcán. Ezek a tiszta
    esetek, amikor 100% vagy 0% a stroke hozzájárulása a halálozáshoz,
    de a valódi történetek többsége nem ilyen, hanem szürke zóna, mint
    azt az előző bekezdés példája is mutatja.

    Ráadásul nem arról van szó, hogy ez „bonyolult” probléma (és majd
    jövőre okosabbak leszünk, és megoldjuk), hanem arról, hogy ez
    *megoldhatatlan* probléma. Valamennyi ok *hozzájárult* a halálához,
    nyilván nem tett jót, hogy szívelégtelen, nem tett jót, hogy
    cukorbeteg, tehát, ha szigorúan vesszük, valami olyasmit kellene
    mondani, hogy 33 százalékban a szívelégtelenségbe halt bele, 19
    százalékban a cukorbetegségbe és 48 százalékban a stroke-ba.
    (Természetesen ezek a számok teljesen hasraütésszerűek.) Hiába is
    lenne *elvileg* ez a helyes, az orvosi realitásnak megfelelő kép,
    ilyet nem csinálunk – annyiban érthető módon is, hogy ember legyen a
    talpán, aki ezeket a százalékokat megmondja.

    Ez tehát a probléma; annyit azért fontos hangsúlyozni, hogy a dolog
    egy részletekbe menően szabályozott, egységes algoritmus alapján
    zajlik (ez nyilvánosan elolvasható, mind a
    [KSH-nál](https://www.ksh.hu/docs/hun/info/02osap/torveny/d159006_2.doc),
    mind a
    [WHO-nál](https://icd.who.int/browse10/Content/statichtml/ICD10Volume2_en_2019.pdf)),
    tehát bár a problémára nincs varázsütésszerű megoldás, de legalább
    az elmondható, hogy a pontos besorolási döntés, még ha nem is
    vitathatlan, de jó esetben legalább egységes országok között is, és
    időben is.

2.  Az adatminőség kérdése

    Úgy tűnhet, hogy ilyen szempontból nincs nagy gond, sőt, valójában
    még jobb is a helyzet, mint az incidencia-jellegű adatoknál, hiszen
    míg egy diagnózist el lehet nézni, azért legkésőbb a halálnál,
    felboncolva az alanyt, csak kiderül egész bizonyosan, hogy mi baja
    volt. Valójában azért ez ennyire biztosan nem igaz (kezdve azzal,
    hogy egyáltalán nincs minden elhunyt felboncolva; Magyarországon
    2021-ben 23% volt a [boncolási
    arány](https://gateway.euro.who.int/en/indicators/hfa_545-6410-autopsy-rate-for-all-deaths)
    és ez még egy kiugróan magas szám, a legtöbb nyugati országban ez a
    10%-ot sem éri el), ráadásul további problémák is vannak.

    Az első kérdés a használt osztályozási rendszer, a Betegségek
    Nemzetközi Osztályozása (röviden BNO) ami meghatározza, hogy milyen
    halálokok léteznek és hogy azokba milyen algoritmus szerint kell
    besorolni az elhunytakat. A gond az, hogy az orvosi tudás
    bővülésével ez folyamatosan változik, tipikusan bővül, mégpedig elég
    drámaian: a BNO 1900-ban bevezetett első változata 191 kódot
    tartalmazott, a 2022-ben elindított 11. revízió pedig 17 ezret…
    Közben bizonyos kódokat törölnek is, vagy egybevonnak másokkal, a
    bővülés sem feltétlenül új betegségek megjelenését jelenti, hanem
    meglevőek részletesebb szétbontását és így tovább. Az [külön
    tudomány](https://www.tandfonline.com/doi/abs/10.1080/01615440.1996.10112731),
    hogy az eltérő verziókat hogyan kell összekapcsolni, de látszik,
    hogy ez tökéletesen soha nem tehető meg. Ez eleve korlátozza az
    egységességet, ha különböző időpontokról beszélünk.

    Valójában ennél kicsit rosszabb a helyzet, mert egy revízió
    érvényességi időtartamán belül is lehetnek változások. Ezt azért
    említem külön, mert a magyar adatokat érinti: 1995-től 2022-ig a 10.
    revízió volt érvényben, mégis, 2005-től érzékelhetően megváltoztak a
    számok. (Az össz-halálozás természetesen adott, így ez lényegében a
    különböző kategóriák közötti átrendeződést jelenti.) Ennek az oka
    egyrészt, hogy ekkor [tértek
    át](https://www.ksh.hu/docs/hun/modsz/nep_modsz.html) a KSH-nál az
    automatikus, gépi haláloki besorolási rendszerre a korábbi kézi
    besorolás helyett, egy új halottvizsgálati bizonyítvány formátum,
    valamint szigorúbb orvos-szakmai ellenőrzés elindításával együtt,
    másrészt ekkor [vezették
    át](http://diploma.uni-sopron.hu/1890/1/kplhi1604.pdf) egyben az
    1995 óta a WHO által kiadott apróbb, revízión belüli változásokat.
    Ezek miatt a 2005 előtti és utáni magyar adatok összehasonlítása
    esetén óvatosan, erre tekintettel kell eljárni.

    Természetesen a kódolás minősége is kérdés lehet, történhetnek
    adminisztratív hibák, hiányos vagy téves kódolások, nem biztos, hogy
    tökéletes a jelentési fegyelem stb., ez különösen igaz, ha a fejlett
    világon túli [országokat
    is](https://iris.who.int/bitstream/handle/10665/269355/PMC2624200.pdf)
    be akarjuk vonni a vizsgálatokba. Több nemzetközi tanulmány
    vizsgálta a kódolási minőséget (például az
    [autóbalesetekre](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10523810/)
    vagy épp az
    [esésekre](https://bmcgeriatr.biomedcentral.com/articles/10.1186/s12877-021-02744-3)
    vonatkozóan); de talán még érdekesebbek azok a nagyon izgalmas hazai
    vizsgálatok, melyek azt [vetették
    egybe](https://akjournals.com/view/journals/650/163/37/article-p1481.xml),
    hogy a Nemzeti Rákregiszterben szereplő adatok hogyan viszonyulnak a
    – KSH-s – haláloki besoroláshoz: egy eredményt kiemelve, 2018-ban 32
    586 halálozás volt rosszindulatú dagantként besorolva, ebből 29
    970-et „sikerült megtalálni” a Rákregiszterben.

    Mindezek a problémák hatványozottan igazak az emlegetett régi
    adatokra: szép-szép, hogy megvan már 1603-ból is London haláloki
    adatbázisa, de vajon mire megyünk azzal, hogy hányan [haltak
    meg](https://worldhistorycommons.org/londons-bill-mortality)
    fényemelkedésben vagy ijedtségben? (Ennél azért jobb a helyzet,
    valójában sok betegség beazonosítható, bár az adatminőség nyilván
    ott is hihetetlenül rossz mai szemmel nézve. De azért ne becsüljük
    le: például a pestis-járványok lefolyása [kiválóan
    rekonstruálható](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0008401)
    ilyen adatokból is.)

3.  Csak olyan betegségeknél jó, aminél van egyáltalán releváns
    halálozás

    Ha valaki a megfázással szeretne foglalkozni, akkor nem sokra megy a
    halálozási adatokkal.

4.  A halálozás egybeméri az incidenciát és a gyógyítás hatásfokát

    Az előnyök között említettük azt az értelmezést, ami úgy kezdődik,
    hogy „ha a halálozási arány állandó” – de mi van ha nem? Ha változik
    időben (például mert fejlődik az orvostudomány), akkor sajnos mégsem
    működik az előnyöknél elmondott logika, és nem tudunk következtetni
    a halálozásból az előfordulásnak még a relatív viszonyaira sem: ha
    csökken a halálozás, akkor nem biztos, hogy csökken az előfordulás,
    lehet, hogy egyszerűen csak hatékonyabbá vált a gyógyítás. Ha eltér
    a halálozási arány országok között (például mert valahol jobb
    kezelési lehetőségek érhetőek el), akkor nem vethetőek össze ezzel a
    logikával a különböző országok: nem biztos, hogy ahol kevesebb halál
    van, ott kevesebb – pláne pontosan arányban kevesebb – a
    megbetegedés, lehet, hogy csak hatékonyabban gyógyítanak.

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

Ezzel elérünk a témának egyfelől a sava-borsához, másfelől az egyik
legnehezebb részéhez. A következőkben néhány idézet részletes
kivesézésével igyekszem bemutatni a legfontosabb nehézségeket,
buktatókat, illetve szempontokat, amikre tekintettel kell lenni az
adatok értelmezésénél.

### Halálozás Svédországban és Chile-ben

*Egy évben az akkor 13,5 millió lakosú Chile-ben 76 261-an haltak meg
(halálozási ráta: 5,7 per 1000 fő per év), a 8,7 millió lakosú
Svédországban 97 008-an (halálozási ráta 11,2 per 1000 fő per év), tehát
Svédország mortalitása kétszerese volt Chile-ének.*

Az állítás eleve elég meglepő lehet, de nem hazudok: a számok pontosan
ezek. (Milyen sokszor előkerül ez a helyzet! Nem csak úgy lehet valami
hamis, ha nem igazak benne a számok, az interpretációval is lehet teljes
félrevezetést elérni.)

Mi történik? Azonnal megértjük – bár ettől valószínűleg még nem lesz
kevésbé meglepő, ha valaki először látja! – ha megnézzük ugyanezeket a
számokat, de lebontva életkor szerint. Az egyszerűség kedvéért csak két
életkori kategóriát használva, ezek a tényadatok:

| Korcsoport       | Svédország                  | Chile                        |
|------------------|-----------------------------|------------------------------|
| 70 év alatt      | 21 381 / 7 576 522 = 2,82   | 37 062 / 12 917 070 = 2,87   |
| 70 év és felette | 75 627 / 1 115 126 = 67,8   | 39 199 / 571 131 = 68,6      |
| *Összességében*  | *97 008 / 8 691 648 = 11,2* | *76 261 / 13 488 201 = 5,65* |

A dolog első ránézésre teljesen paradoxnak tűnik. Mármint nem
epidemiológiailag, hanem matematikailag! Hogyan lehetséges, hogy ha az
egész populációt szétosztjuk két részre, akkor mindkettőben Svédország a
jobb, viszont együttvéve meg drámaian rosszabb? Lehetséges egyáltalán
ilyen?! Sokan azt mondanák, hogy nem, ne vicceljünk, hát ha a fiatalok
körében is jobb a svéd helyzet, meg az idősek körében is, akkor
*nyilván* összességében is jobb – csakhogy ez nem így van. (Ha valaki
nem hiszi, adja össze a számokat és ellenőrizze!)

Mi a magyarázat? Jobban megnézve a számokat – tényleg érdemes e ponton
megállni, és egy percet rászánni! – kiviláglik a jelenség oka.

A magyarázat az *eltérő korfa*…! Chile-ben mutatóban volt a vizsgált
évben 70 év feletti ember (fejlődő ország, fiatal korösszetétellel),
addig Svédországban azért bőven volt ilyen lakos (fejlett ország,
idősödő társadalom). Érdemes megnézni, hogy Chile lélekszáma másfélszer
akkora, mint Svédországé, mégis mindössze feleannyi 70 évnél idősebb
lakos van! Innen már összerakható a történet: igaz, hogy külön-külön
mindkét korcsoportban jobb Svédország, de azért a svéd idősek halálozása
még mindig rosszabb, mint a chile-i fiataloké, így a több svéd idős, a
körükben mért nagyobb halálozással, „lerontja” az össz-statisztikát. Úgy
is fogalmazhatunk, hogy a halálozási ráta egy súlyozott átlag: az egyes
korcsoportok halálozási rátáinak átlaga, súlyozva a korcsoport
lélekszámával. A „súlyozott átlag” itt nem egy irodalmi szófordulat: a
szó szigorú matematikai értelmében is erről van szó. A svéd lakosság (7
576 522 / 8 691 648 = ) 87,2%-a 70 év alatti, (1 115 126 / 8 691 648 = )
12,8%-a a fölötti, és csakugyan: 87,2% $\cdot$ 2,82 + 12,8% $\cdot$ 67,8
= 11,2! Hasonlóképp a chile-i korfa szerint 95,8% 70 év alatti, 4,2% a
fölötti, és valóban, 95,8% $\cdot$ 2,87 + 4,2% $\cdot$ 68,6 = 5,7.
Látszik tehát a magyarázat: hiába jobb Svédország mindkét korcsoportban
külön-külön, ott az idősebbkori, rosszabb értékek jóval nagyobb súlyt
kapnak, mint Chile-ben!

Egy szó mint száz, előfordulhat, hogy egy országban minden korcsoportban
jobb a halálozás, összességében mégis rosszabb.

Mindez megmutatja ez első nehézséget a fejezetcímben foglalt kérdés
megválaszolásában, tehát az okok feltárásában: azt mondtuk, hogy arra
leszünk kíváncsiak (többek között), hogy hol nagyobb a halálozás,
mondván, hogy ott annak valami oka van, de mint látjuk, már annak
megállapítása sem egyértelmű, hogy *egyáltalán hol nagyobb* a
halálozás…! Látszólag Svédországban, de valójában Chile-ben.

Sőt, ez a nehézség nem csak a „hol” kérdését érinti. A fenti probléma
ugyanis nem csak különböző országok ugyanazon évben mért adatainál
jelentkezhet, hanem ugyanazon ország különböző évben mért adatainál is!
A helyzet tökéletesen ugyanaz, csak a „Chile” felirat helyett képzeljük
oda a táblázatban azt, hogy „a vizsgált ország korábban”, a „Svédország”
helyett pedig azt, hogy „a vizsgált ország később”. (Ugyanaz az ország
idősödött; noha a konkrét mérték a fenti táblázattal extrém, de maga a
jelenség teljesen tipikus a legtöbb fejlett országban.) Mit látunk? Azt,
hogy a halálozási ráta sokkal rosszabb a későbbi időpontban, miközben a
helyzet a valóságban kicsit még javult is! Tehát a „mikor” kérdéssel
próbálkozva is *teljesen fals* választ kapnánk, mert azt hisszük, hogy
akkor jobb a helyzet, amikor valójában rosszabb, tehát már ott tévútra
mennénk, hogy egyáltalán melyik időszakban kell keresnünk a rosszabb
halálozás okait.

(A fentiekben mindenhol egyszerűen a halálozások számát használtam; ez
olyan, mintha a halálok a „bármely okból bekövetkező halálozás” lenne.
Természetesen a leírtak pontosan ugyanúgy igazak akkor is, ha valamely
konkrét halálokból vagy halálokokból bekövetkező halálozások számáról
beszélünk.)

Mi lehet erre a problémára a megoldás? Az egyik lehetőséget rögtön a
táblázat mutatja: ne az összességében vett halálozási rátát használjuk,
hanem az egyes életkorokét. Tehát ne azt mondjuk, hogy „11,2 az 5,7-tel
szemben”, hanem azt, hogy „2,8 a 2,9-cel szemben *és* 68 a 69-cel
szemben”. Máris rendben vagyunk…! (Ezt a módszert szokták rétegzésnek
nevezni a biostatisztikában; jelen esetben életkor szerinti rétegekre
bontottuk a teljes populációt.) A dolog működik, ezt az előbbi mondatok
is mutatják, de azért hátránya is van ennek a módszernek. Az egyik, ami
szintén rögtön látható, hogy nem *egy* eredményt kapunk, hanem többet.
Jelen esetben kettőt, ami nem tűnik vészesnek, de ez csak azért volt,
mert nagyon széles életkor-tartományokra bontottunk; ha szűkebb életkori
csoportokat, például 5 év széles kategóriákat használunk, akkor akár
nagyon sok eredményünk is lehet. Ez minimum nem praktikus (ki szeretné,
ha arra a kérdésre, hogy „hogyan viszonyul Svédország mortalitása
Chile-hez?” egy számokkal teleírt lapot kapna, azzal, hogy tessék, ez a
válasz…), de statisztikai kérdéseket is felvet, mert ha nagyon szűk
korcsoportokat használunk, akkor kicsi lesz az egyes csoportok
lélekszáma, kevés halálozással, és így az egyes korcsoportok halálozási
rátainak a becslése bizonytalanná válik, mert kevés alanyból kell
megtennünk.

Itt jön a második megoldás ötlete. A módszer neve: standardizálás. A
standardizálás is egy rétegzéssel indít, de utána továbbmegy: az egyes
korcsoportok halálozási rátáit *újra* összerakja egyetlen számba,
súlyozott átlagként – pontosan ugyanúgy, mint a félrevezető számítás,
csak épp ügyesebben. Mert mi volt a probléma? Az, hogy az egyes
korcsoportok halálozási rátáit *különböző* súlyokkal raktuk össze – hát
akkor egyszerű a megoldás: rakjuk össze, de *ugyanazokkal* a súlyokkal!
Legyen például, hasraütésszerűen mondok valamit, a súlyozás, tehát a
korfa a következő: 70 év alattiak 90%, fölöttiek 10%. Ezt az egységes
korfát szokták referencia-populációnak vagy standard populációnak is
nevezni. És ezt fogjuk használni – most jön a lényeg! – *mindegyik*
országnál! Próbáljuk ki, az ezzel kapott eredmény Svédország esetében
90% $\cdot$ 2,82 + 10% $\cdot$ 67,8 = 9,32, míg Chile esetében 90%
$\cdot$ 2,87 + 10% $\cdot$ 68,6 = 9,44. Ezek a számok, a 9,32 és a 9,44
többé már nem bírnak közvetlen tartalommal (hiszen egy fiktív korfához
tartoznak), de, ami kulcsfontosságú: összehasonlíthatóak egymással, az
egyes országok eltérő korfái ellenére is. És nézzük meg, csakugyan: így
már Chile a rosszabb és Svédország a jobb! Ezeket a halálozási rátákat
szokták standardizált (vagy még teljesebb nevén direkt standardizált)
halálozási rátának nevezni. Ez már összehasonlítható különböző országok
között is; természetesen az értéke függ attól, hogy milyen
referencia-populációt használtunk (ezt mindig meg kell adni). A
korábbiakban kiszámolt halálozási rátákat megkülönböztetésül nyers
halálozási rátának szokták hívni.

Van még más megoldás is (például a regresszió, ami sok szempontból
korszerűbb is), de az epidemiológiai irodalomban a mai napig a
standardizált halálozási ráta a legáltalánosabban használt eszköz a
különböző országok, vagy épp különböző időpontok
összehasonlíthatóságának megteremtésére.

Egyetlen apró szépséghiba van: az, hogy valójában ez nem „általában”
teremti meg az összehasonlíthatóságot, hanem egy konkrét tényezőre, az
életkorra tekintettel. Annak a szerepét szűri ki – semmi mást nem.
Esetleg még nem szerint lehet rétegezni, vagy standardizálni, mert a
halálozási adatokat tudjuk nem szerint is lebontva. De ennyi!
Elképzelhetjük például, hogy az országok eltérnek abban, hogy a lakosság
mekkora része cukorbeteg. (Vagy épp ugyanazon országban eltér különböző
években!) Megint visszamehetünk az előző táblázatra, csak most vegyük
úgy, hogy a sorok nem az életkori csoportok, hanem az egyik az, hogy
„nem cukorbeteg”, a másik az, hogy „cukorbeteg”. Ekkor pontosan
ugyanabba a problémába futunk bele: lehet, hogy egy ország a
cukorbetegek körében is jobb halálozási rátát produkál, a nem
cukorbetegek körében is jobb halálozási rátát produkál – de
összességében mégis rosszabbat! Ezzel azonban semmit nem fogunk tudni
kezdeni. Nem azért, mert standard populáció nincsen (azt bármikor
gyárthatunk, legyen mondjuk 5% cukorbeteg, 95% nem az, tessék, máris
megvan), hanem azért, mert halálozási ráta nincsen külön cukorbetegekre
és nem cukorbetegekre! Az országok közlik a halálozási számokat nem és
életkor szerint, de nem közlik cukorbetegség szerint. Ezzel tehát nem
tudunk ilyen módszerrel mit kezdeni.

(Zárójelben érdemes hozzátenni, hogy az is egy kérdés lehet, hogy ha
lenne is ilyen adatunk, biztosan ki akarnánk-e szűrni a cukorbetegség
hatását. Lehet ugyanis a mellett érvelni, hogy ha egy országban azért
magasabb a halálozási ráta, mert több a cukorbeteg, azt a legkevésbé sem
kell „kiszűrni”, ellenkezőleg, azt ki kell mutatni, hiszen a probléma
része. Ez már végképp nagyon messzire vezető kérdéskör, de valójában az
attribúció kérdése van a háttérben: mit szeretnénk betudni az ország
hatásának és mit nem? A fenti érvelés mögött az van, hogy az ország
„tehet” arról, hogy mennyi cukorbeteg van, így azt ne szűrjük ki. Ezzel
szemben arról „nem tehet”, hogy milyen a korfa, ezért kell azt kiszűrni
az összehasonlításhoz. Amint talán érzékelhető, ezek már ingoványos, nem
egyértelműen definiált terület, de abban a részében nem szokott kétség
lenni, hogy a korfa hatását ki kell szűrni, ezért általános a
standardizált ráta használata a nyers helyett.)

Összefoglalva mindezeket, láthatjuk, hogy már az sem nyilvánvaló kérdés,
hogy egyáltalán milyen halálozási számot kell országok, vagy évek között
összehasonlítani. A problémák azonban nem érnek ezzel véget.

### Dohányzás és a rák

*A dohányzás rákot okoz, csak meg kell nézni, ahol több a dohányzó, ott
több a rákos is!*

Igaz ez, tényleg több a rákos ott, ahol több a dohányzó? Igen, igaz, az
alábbi ábra mutatja a helyzetet az Európai Unió országaiban:

![](README_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

A pontok mindegyike egy országot jelöl; az ábrán behúztam az ezekre
legjobban illeszkedő egyenest is. Ahogy látszik, a legkevesebbet
dohányzó országok körében látható 220 körüli értékről 290 körülire
emelkedik az átlagos rák-halálozási ráta ahogy nő a dohányzók aránya. Ez
több mint 30% növekedés, avagy, másként kifejezve, 10 millió lakosra
7000-rel több rákos halálozás évente, tehát nem csak van összefüggés, de
elég drámai mértékű (Magyarországon általában évente 30 ezernél kicsit
több rákos halálozás van).

Látszólag tehát végeztünk is: valóban megmutattuk, hogy a dohányzás
rákot okoz! Immár teljesen tudományos alapon, konkrét számokkal,
adatokkal, pontokkal, legjobban illeszkedő egyenessel. Ha szeretnénk,
lehet még drámaibbá is tenni, például: „ha vissza tudnánk szorítani a
dohányzást hazánkban, 7000-rel kevesebben halnának meg rákban évente!”…

Első ránézésre úgy tűnik, hogy ezzel az elemzéssel nemhogy gond nincsen,
hanem voltaképp ezért csináltuk az egész adatgyűjtést. Hiszen mit
mondtunk az elején? Hogy azért érdekel minket, hogy hol, mikor és ki hal
meg, hogy ebből következtessünk az okozati viszonyokra. Tessék, ott ahol
többet dohányoznak, többen halnak meg rákban.

Igen ám, de. Mi van, ha elkészítjük *hajszálpontosan ugyanezt* az ábrát,
csak épp nem a dohányzást, hanem a cukorbetegek arányát ábrázoljuk?

![](README_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

Tehát a cukorbetegség is hozzájárul a rákhoz: ahol több a cukorbeteg,
ott magasabb a rákhalálozás is.

Rendben, eddig semmi gond, miért ne lehetne, hogy a dohányzás is
hozzájárul a rákhoz, meg a cukorbetegség is? Teljesen logikus is. Igen
ám, csak nézzük meg ezt az ábrát:

![](README_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

Úgy tűnik a kettő egymással is összefügg! Ahol több a dohányzó, ott több
a cukorbeteg is. Rendben, ez sem egy egetrengető dolog eddig…

…viszont, ha jobban elgondolkodunk ezen, akkor befészkelheti az agyunkba
magát egy nyugtalanító gondolat. Ha a dohányzás és a cukorbetegség
összefügg, és a cukorbetegség rákot okoz, akkor nem lehet, hogy a
dohányzásnak igazából nincs is szerepe, és az első ábrán csak azért
láttuk azt, mintha lenne, tehát, hogy a többet dohányzó országokban
azért volt több rákos, mert azokban az országokban *egyúttal* a
cukorbeteg is több volt? És ez volt a *valódi* oka annak, hogy ott több
a rákos, miközben a dohányzásnak nincs is semmi szerepe…?

A rövid válasz: de. Sajnos lehet. Nem *biztos*, hogy ez a magyarázat, de
lehetni lehet. És ezzel elértünk az ilyen típusú orvosi adatok
értelmezésének talán [legnagyobb
csapdájához](https://tamas-ferenci.github.io/FerenciTamas_AzOrvosiMegismeresModszertanaEsAzOrvosiKutatasokKritikusErtekelese/),
amit – magyarban is gyakran használt angol kifejezéssel –
confoundingnak, azaz „egybemosódásnak” szoktak hívni. A kifejezés nagyon
találó: mi van, ha a dohányzásbeli eltérés egybemosódik a
cukorbetegségbeli eltéréssel? Ez esetben simán előfordulhat, hogy csak a
dohányzást vizsgálva azt *hisszük*, hogy van kapcsolat, miközben a
valóságban nincsen – a dolog látszólagos, ami azon keresztül érvényesül,
hogy a többet dohányzó országokban több a cukorbeteg, és *az* a valódi
oka a több rák-halálozásnak.

Hogy lássuk, ez nem csak elméleti lehetőség, íme egy konkrét példa. Egy
gondolatkísérlet, a szónak abban az értelmében, hogy a következőkben
látott számok nem tényadatok, mint fent, hanem én gyártottam le ezeket a
példa kedvéért egy képletet használva – ez azért lesz nagyon jó, mert
így *biztosan* tudhatjuk, hogy mi van a háttérben, hiszen én állítottam
be. (A fenti tényadatokon ezt nem tudjuk vizsgálni, mert ott mi magunk
sem tudhatjak, hogy mi a valódi helyzet.) Hogy könnyebb legyen az
ábrázolás, a cukorbetegséget nem folytonos változónak tekintettem – hány
százalék cukorbeteg – hanem binárisnak: vagy sok cukorbeteg van (10%)
vagy kevés cukorbeteg van (5%) egy országban. Íme a szimulált adatok;
érdemes a továbbolvasás előtt jól megnézni, és kitalálni, hogy vajon mi
a valódi összefüggés, ami alapján gyártottam ezeket:

![](README_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

Mit látunk ezen az ábrán? Egyrészt azt, hogy a dohányzásnak nincs
hatása: akár sok cukorbeteg van az országban, akár kevés, a dohányzás
változása nem jár semmilyen érzékelhető változással a halálozásban. A
másik, ami rögtön látszik, hogy a cukorbetegségnek viszont nagyon is van
hatása: a több cukorbeteg magasabb halálozással jár együtt. A harmadik,
hogy a dohányzás és a cukorbetegség összefügg: a többet dohányzó
országokban inkább több a cukorbeteg is. Mindezek jelen esetben teljesen
biztosak, mert utólag elárulom, hogy így generáltam az adatokat: a
halálozási ráta egyenlő 200 plusz a cukorbetegek arányának kétszerese
plusz egy kis véletlen zaj.

És most jön a csavar: mit látunk, ha *csak* a dohányzást nézzük,
cukorbetegségről nem tudva, vagy azt figyelmen kívül hagyva? Ezt:

![](README_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

Ami nem más, mint a fenti ábra, csak épp színek nélkül. És mi látszik
rajta? Az, hogy a dohányzás és a rák-halálozás között pozitív
összefüggés van. Pedig valójában nincsen semmi! – és ez most ezúttal
teljesen biztos, hiszen így generáltuk az adatokat.

A helyzet tovább is durvítható:

![](README_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

Mi látható itt? Ha kevés cukorbeteg van az országban, akkor a dohányzás
csökkenti (!) a rák-halálozást. Ha sok van, akkor *szintén* csökkenti. A
dohányzás tehát mindenképp jót tesz, viszont ha csak a dohányzás hatását
vizsgáljuk, elfelejtve a cukorbetegséget (azaz színek nélkül nézünk az
előbbi ábrára), akkor *itt is* azt látjuk, hogy ahol több a dohányzó,
ott több a rákos is!

A példa tartalmilag ugyan elég abszurd, de az nagyon fontos, hogy
*elvileg* ez is állhat a háttérben: mint a fenti példa bizonyítja,
*attól még*, mert több a rák-halálozás a többet dohányzó országokban,
akár az is elképzelhető, hogy a dohányzás *csökkenti* a rák-halálozást!
(Ha a többet dohányzó országokban több a cukorbeteg, ami rontja a
halálozást, annyira, hogy a rontó hatása nagyobb mint a dohányzás javító
hatása.)

Ez a confounding problémája! Az a megállapításunk (mert ez így van, ez
tényadatok kérdése), hogy a többet dohányzó országokban magasabb a
rák-halálozás, jelentheti azt, hogy a dohányzás rákot okoz, azt, hogy a
dohányzásnak nincs köze a rákhoz, és azt is, hogy a dohányzás véd a rák
ellen. Önmagában tehát ez az együttjárás jellegű megállapítás csak
nagyon-nagyon gyenge bizonyíték az okozati kapcsolatról, tehát arról,
hogy a dohányzás rákot okoz.

Fontos, hogy a „nagyon gyenge bizonyíték rá” természetesen *nem* azt
jelenti, hogy „bizonyíték az ellentétére”, tehát az, hogy valahol
szemfüles módon felismertük a confounding-ot, nem azt jelenti, hogy
bebizonyítottuk, hogy nincs összefüggés, pláne nem azt, hogy
bebizonyítottuk, hogy ellenkező összefüggés van – egyszerűen annyit
jelent, hogy az adatokból nem igazán tudtunk meg semmit. A dohányzás és
a rák-halálozás összefüggésének kiinduló idézetben szereplő bizonyítéka
valóban confounding-gal terhelt, de ennek felismerése nem jelenti azt,
hogy bebizonyítottuk, hogy nincs összefüggés a dohányzás és a rák között
között, pláne, hogy valójában véd a dohányzás. Egyszerűen annyit jelent,
hogy a fenti adatok *önmagukban* igen kevéssé bizonyítják, hogy rákot
okoz; ettől még okozhat, csak ez konkrétan egy nagyon gyenge
alátámasztása ennek.

Ássunk egy kicsit mélyebbre, hogy jobban megértsük a confounding-ot. Mi
vezetett ehhez a helyzethez…?

Az, hogy olyan országokat hasonlítottunk össze, amik nem *csak* egy
tényezőben tértek el. Összehasonlítottunk kevesebbet és többet dohányzó
országokat, és ha köztük *csak* a dohányzás ténye lett volna az egyetlen
eltérés, akkor ha találunk különbséget a rák-halálozásban, joggal
következtethettünk volna arra, hogy az a dohányzás miatt van. (Vagy a
véletlen ingadozás miatt, de ez kezelhető statisztikai eszközökkel.)
Hiszen más eltérés nincs, tehát szükségképp ez kell legyen a különbség
oka. A probléma az, hogy a többet és kevesebbet dohányzó országok nem
*csak* a dohányzás tényében térnek el. Sok minden másban is eltérnek – a
fenti példában a cukorbetegség előfordulásában – márpedig ha egyúttal
más tényezőben vagy tényezőkben is eltérnek, akkor onnantól kezdve, ha
találunk is különbséget a rák-halálozásban, nem tudhatjuk, hogy ennek mi
a *valódi* oka: a dohányzás, a dohányzással együtt járó egyéb eltérések,
vagy esetleg ezek valamilyen keveréke…?

Ez a confounding problémájának a magja, és mindig jelentkezik, ha olyan
csoportokat hasonlítunk össze, amik nem csak egyetlen tényezőben térnek
el. A valóság ráadásul ennél is sokkal, sokkal zűrösebb, hiszen az
országok nem két tényezőben térnek el, hanem sok százban, ezerben,
beláthatatlan számúban!

Egyetlen megjegyzés a végére. Ha valaki alaposan végiggondolja, akkor
feltűnhet, hogy igazából az előző, életkoros példa is hasonlít ehhez a
helyzethez: ott is összehasonlítunk csoportokat úgy, hogy nem csak az
ország ténye tér el, hanem az életkori összetétel is. A dolog nem
véletlen: valójában *az is* egy confounding! Pontosan ugyanaz a helyzet,
csak nem dohányzással és cukorbetegséggel, mint ami eltér országok
között, hanem korfával. Valójában tehát mindenhol a confounding volt a
probléma.

### Curry-evés Indiában és Magyarországon

*Indiában jóval több curry-t esznek mint Magyarországon, és nézd meg,
jóval kevesebb a halálozás emésztőrendszeri megbetegedésben! Egyél
curry-t az emésztőrendszeri betegségek megelőzésére!*

Ez lényegében az előző érv egy még gyengébb változata, hiszen nem is
több tucat országot nézve vonja le a következtetést, hanem pusztán
kettőből – mégis meglepően gyakran találkozni vele. Egyébként ezért
szeretem: még reklámot is láttam, amiben egy curry-kivonatot tartalmazó
kapszulát ilyesmi szöveggel adtak el, és azért szeretem, mert ez egy
profitorientált cég reklámja, tehát elemi érdeke, hogy működjön, hiszen
a pénze múlik rajta – nincs is kétségem, hogy tényleg működnek a
fentihez hasonló szövegek. Miközben gondoljuk végig, és ez a másik ok,
ami miatt szeretem ezt a példát, hogy itt aztán igazán nem kell hosszas
módszertani fejtegetés a confounding-ról, hogy az emberben felmerüljön:
teljesen tuti biztos, hogy India és Magyarország között az az egyedüli
és kizárólagos különbség, hogy ott sok curry-t esznek, itt meg keveset?
Semmi már eltérés nincs…? De mégis, újra mondom, működik ez a szöveg,
bármennyire is kézenfekvőnek tűnik ez a probléma! Ezért is nagyon
gyakori, hogy orvosi téren félreértések, rosszabb esetben félrevezetések
alapja a confounding (és pont ezért fontos jól ismerni!).

Hosszas magyarázat a fentiek után valószínűleg már nem szükséges: India
és Magyarország között milliónyi különbség van a curry-fogyasztás tényén
túl is, honnan tudjuk, hogy az emésztőrendszeri halálozásban tapasztalt
eltérésért a curry, és nem valamilyen egyéb eltérés (vagy ezek
valamilyen keveréke) a felelős? A probléma ugyanaz: nem *csak* egy
dologban eltérő országokat hasonlítunk össze.

Másként megfogalmazva: lehet, hogy Indiában kevesebb az emésztőrendszeri
halálozás miközben több curry-t esznek – de mi van, ha ott kevesebb
curry-t fogyasztva *még kevesebb* lenne…? Akkor a curry kimondottan
ártalmas!

Ez a gondolat elvezet minket egy másik megfogalmazáshoz: valójában nem
az az érdekes, hogy Magyarországon nagyobb-e az emésztőrendszeri
halálozás mint Indiában, hanem az, hogy egy „képzeletbeli Indiában”, ami
*csak* abban tér el Indiától, hogy kevesebb curry-t esznek, nagyobb-e!
Avagy fordítva, egy „képzeletbeli Magyarországon”, ami *csak* abban tér
el Magyarországtól, hogy több curry-t esznek, kisebb-e. Csakhogy ezt
*nem tudjuk*, mert Magyarország *nem* a fenti „képzeletbeli India”:
igen, kevesebb curry-t eszünk, eddig jó lenne, de sajnos van millió
egyéb eltérés is! És hasonlóan, India *nem* a fenti „képzeletbeli
Magyarország”, hiszen nem *csak* abban tér el, hogy több curry-t esznek.
Ha egy időgéppel visszamennénk Magyarország múltjába, és több curry-t
etetnénk (de *minden mást változatlanul* hagynánk!), akkor kevesebb
lenne az emésztőrendszeri halálozás? Avagy fordítva, ha egy időgéppel
visszamennénk India múltjába, és kevesebb curry-t etetnénk (de *minden
más változatlanul* hagynánk), akkor több lenne az emésztőrendszeri
halálozás?

Ezek a jó kérdések, csak az a probléma, hogy nincs időgép… Így
lényegében egy megfigyelhetőségi problémánk van: két dolgot kellene
összehasonlítani, de bárhogy igyekszünk, ebből egyet nem fogunk ismerni:
tudjuk, hogy mi van Magyarországon kevés curry-vel, de nem tudjuk mi
lett *volna* sokkal, és tudjuk mi van Indiában sokkal, de nem tudjuk mi
lett *volna* kevéssel. Fontos: az se megoldás, ha jövő évtől elkezdünk
rengeteg curry-t etetünk Magyarországon, hiszen akkor ugyanúgy hiányozni
fog a másik információ – soha nem tudjuk meg mi lett *volna*, ha nem
etetünk sok curry-t. Ugyanoda lyukadunk ki: a probléma, hogy nem tudjuk
mi lett *volna* ha *csak* egyetlen tényező változott *volna*.

(Zárójelben: ez a példa teljesen véletlenül egy másik korábbi
megjegyzésemre is illusztrációt szolgáltat: a curry aktív hatóanyaga, a
kurkumin jelen tudásunk szerint *tényleg* jót tehet bizonyos
emésztőrendszeri megbetegedésekben. Csak épp erre nem az a meggyőző
bizonyíték, hogy Indiában kevesebb az emésztőrendszeri betegség…)

### Infarktust okoz-e az új védőoltás?

*Tavaly bevezettek nálunk egy új oltást, és nézd meg idén mennyivel több
az infarktusos halál! Az oltás infarktust okoz!*

Mint volt róla szó, a confounding problémája akkor lép fel, ha nem
*csak* egy tényezőben eltérő csoportokat hasonlítunk össze. Ebből
fakadóan természetesen itt is igaz, hogy ez a probléma nem csak
különböző országok azonos évben vett adatainak vizsgálatakor
jelentkezhet (mint az összes fenti példában szerepelt), hanem ugyanazon
ország különböző évben vett adatainak a vizsgálatakor is. Hiszen a
jelenség ugyanaz: a különböző évek sem *csak* az oltás tényében térnek
el. Innen kezdve a probléma is ugyanaz: ha találunk is különbséget az
infarktus-halálozásban, honnan tudjuk, hogy az az oltás miatt volt, az
évek között milliónyi egyéb eltérés valamelyike miatt, vagy esetleg ezek
valamilyen keveréke miatt…?

Az előző okfejtés megfogalmazása is jól működik: a probléma az, hogy
minket valójában *nem* az érdekel, hogy a későbbi évben több-e az
infarktusos halál, hanem az, hogy egy olyan képzeletbeli évben több-e,
ami *csak* abban tér el a korábbitól, hogy ott már van oltás. Csakhogy a
későbbi év nem felel meg ennek a képzeletbeli évnek, hiszen nem *csak*
az oltás tényében tér el! Megint a megfigyelhetőségi probléma jön elő:
nem tudjuk, hogy mi lett *volna*, ha a későbbi évben nem lett *volna*
oltás – márpedig igazából ehhez kellene viszonyítani. De ezt mi sem
tudjuk, hiszen amikor már van oltás, akkor nem tudhatjuk, hogy mi lett
volna, ha nincs. Több infarktusos halál lett volna? (Az évek közötti
*egyéb* eltérések miatt.) Kevesebb? Ugyanannyi? Nem tudjuk!

Emiatt előállhat az a helyzet, hogy az oltás bevezetése után kevesebb
lett az infarktusos halálozás, de az oltás *mégis* infarktust okoz (ha
oltás bevezetése nélkül még kevesebb lett volna), vagy fordítva, több
lett, de az oltás *mégis* véd az infarktus ellen (ha oltás nélkül még
több lett volna). Ez a confounding problémája.

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
származnak. Ez tartalmazza az egyes jelentést adó országok halálozási
számait életkor, nem, év és halálok szerint lebontva. E tényezők szinte
mindegyike igényel kommentárt:

- A halál oka a Betegségek Nemzetközi Osztályozása (BNO, angolul
  International Classification of Diseases, ICD) szerint van megadva. Ez
  egy gigantikus nemzetközi vállalkozás, melyet több mint egy évszázada
  fejlesztenek, és amely azt célozza meg, hogy az összes ismert,
  relevánsan elkülöníthető betegség nemzetközileg egységes, hierarchikus
  osztályozási rendszere legyen. A WHO adatbázisa 1995-től a BNO 10-es
  változatát használja; ez több mint 11 ezer önálló betegséget
  tartalmaz. (Már létezik BNO-11 is, azonban ennek bevezetése még csak
  jelenleg zajlik, eddig még nem e szerintiek a jelentetett adatok.) E
  verzióban a kód formátuma – és ebből fakadóan a hierarchia – a
  következő. A kód első karaktere egy betű, ami a főcsoportot adja meg
  (pl. C: „rosszindulatú daganatok”). A második és harmadik karakter
  szám, ami ezen belül adja meg a betegséget (pl. C92: „myeloid
  leukaemia”); ezek általában valamilyen logikus – pl. anatómiai vagy
  klinikai – sorrendben vannak megadva (pl. C00-tól C14-ig az az ajak, a
  szájüreg és garat rosszindulatú daganatai vannak, C15 a nyelőcső
  rosszindulatú daganata, C16 a gyomoré és így tovább a tápcsatorna
  mentén). A negyedik karakter a betegség további lebontása, jellemzően
  típus vagy anatómiai lokalizáció szerint (pl. C925: „akut
  myelomonocytás leukaemia”). A WHO ezt az első 4 karaktert kontrollálja
  központilag, az 5. karaktert az egyes országok szabadon használhatják
  fel saját – finanszírozási, tudományos-statisztikai vagy egyéb célt
  szolgáló – osztályozásukra (pl. Magyarországon C9251: „Akut
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
  ország/év melyik csoportba tartozik. Az sem biztos, hogy egy ország
  minden évben ugyanazt a bontást használja.)
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
egy olyan
[táblázat](https://apps.who.int/gho/data/node.metadata.COUNTRY?lang=en),
melyben a szokásosabb kódok is megtalálhatóak e mellett, így ez
lecserélhető valamilyen bevettebb kódra; én most a [háromjegyű ISO
kódot](https://www.iso.org/iso-3166-country-codes.html) fogom a
későbbiekben használni az egyértelmű azonosításhoz:

``` r
CountryCodes <- fread(
  "https://apps.who.int/gho/athena/data/xmart.csv?target=COUNTRY&profile=xmart")
```

Nézzük meg, hogy ez összekapcsolható-e a korábbi táblával, azaz, minden
ország(kód) megvan-e:

``` r
unique(merge(RawData, CountryCodes[, .(Country = MORT, CountryName = DisplayString, iso3c = ISO,
                                       Region = WHO_REGION_CODE)], by = "Country",
             all.x = TRUE)[is.na(iso3c)]$Country)
```

    ## [1] 1303 3283

Ez két egészen minimális terület, de a teljesség kedvéért pótoljuk ki
(szerencsére a WHO táblázatában kézzel megtalálhatóak, csak a
mortalitási tábla szerinti kód nincs feltüntetve valamiért):

``` r
CountryCodes <- rbind(CountryCodes,
                      data.table(MORT = c(1303, 3283),
                                 DisplayString = c("Mayotte", "Occupied Palestinian Territory"),
                                 ISO = c("MYT", "PSE"),
                                 WHO_REGION_CODE = c("", "EMR")), fill = TRUE)
```

Most már végrehajthatjuk veszteség nélkül az összekapcsolást:

``` r
RawData <- merge(RawData, CountryCodes[, .(Country = MORT, CountryName = DisplayString,
                                           iso3c = ISO, Region = WHO_REGION_CODE)],
                 by = "Country")
```

Azért, hogy felesleges adatokat ne tároljunk, muszáj egy kicsit
előrefutni: betöltjük a lélekszám-adatokat is a HMD-ből (részleteket
lásd a következő pontban), hogy csak azokat az országokat őrizzük meg,
amikhez van lélekszám-adat:

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

Egyedül arra kell vigyázni, hogy a HMD-ben bizonyos országok kódjai,
amik a fájlnév elején jelennek meg, nem ISO-kódok; ezeket – hogy az
ISO-kódokat ne kelljen bántani – a fájlok átnevezésével oldjuk meg:

    ## [1] TRUE

    ## [1] TRUE

    ## [1] TRUE

    ## [1] TRUE

    ## [1] TRUE

    ## [1] TRUE

    ## [1] TRUE

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
knitr::kable(RawData[, as.list(prop.table(table(factor(List, levels = unique(RawData$List))))),
                     .(CountryName)][order(`104`, decreasing = TRUE)])
```

| CountryName                                          |       104 |       103 |       10M |
|:-----------------------------------------------------|----------:|----------:|----------:|
| Canada                                               | 1.0000000 | 0.0000000 | 0.0000000 |
| Chile                                                | 1.0000000 | 0.0000000 | 0.0000000 |
| United States of America                             | 1.0000000 | 0.0000000 | 0.0000000 |
| China, Hong Kong Special Administrative Region       | 1.0000000 | 0.0000000 | 0.0000000 |
| Israel                                               | 1.0000000 | 0.0000000 | 0.0000000 |
| Japan                                                | 1.0000000 | 0.0000000 | 0.0000000 |
| Austria                                              | 1.0000000 | 0.0000000 | 0.0000000 |
| Belarus                                              | 1.0000000 | 0.0000000 | 0.0000000 |
| Croatia                                              | 1.0000000 | 0.0000000 | 0.0000000 |
| Czechia                                              | 1.0000000 | 0.0000000 | 0.0000000 |
| Denmark                                              | 1.0000000 | 0.0000000 | 0.0000000 |
| France                                               | 1.0000000 | 0.0000000 | 0.0000000 |
| Germany                                              | 1.0000000 | 0.0000000 | 0.0000000 |
| Greece                                               | 1.0000000 | 0.0000000 | 0.0000000 |
| Hungary                                              | 1.0000000 | 0.0000000 | 0.0000000 |
| Italy                                                | 1.0000000 | 0.0000000 | 0.0000000 |
| Luxembourg                                           | 1.0000000 | 0.0000000 | 0.0000000 |
| Norway                                               | 1.0000000 | 0.0000000 | 0.0000000 |
| Poland                                               | 1.0000000 | 0.0000000 | 0.0000000 |
| Portugal                                             | 1.0000000 | 0.0000000 | 0.0000000 |
| Spain                                                | 1.0000000 | 0.0000000 | 0.0000000 |
| Switzerland                                          | 1.0000000 | 0.0000000 | 0.0000000 |
| United Kingdom of Great Britain and Northern Ireland | 1.0000000 | 0.0000000 | 0.0000000 |
| United Kingdom, England and Wales                    | 1.0000000 | 0.0000000 | 0.0000000 |
| United Kingdom, Northern Ireland                     | 1.0000000 | 0.0000000 | 0.0000000 |
| United Kingdom, Scotland                             | 1.0000000 | 0.0000000 | 0.0000000 |
| Australia                                            | 1.0000000 | 0.0000000 | 0.0000000 |
| New Zealand                                          | 1.0000000 | 0.0000000 | 0.0000000 |
| Republic of Korea                                    | 0.9699473 | 0.0300527 | 0.0000000 |
| Lithuania                                            | 0.9592007 | 0.0407993 | 0.0000000 |
| Belgium                                              | 0.9587635 | 0.0412365 | 0.0000000 |
| Sweden                                               | 0.9227444 | 0.0000000 | 0.0772556 |
| Netherlands (Kingdom of the)                         | 0.8470865 | 0.0000000 | 0.1529135 |
| Ireland                                              | 0.8322936 | 0.1677064 | 0.0000000 |
| Iceland                                              | 0.7589324 | 0.2410676 | 0.0000000 |
| Bulgaria                                             | 0.7055724 | 0.2944276 | 0.0000000 |
| Latvia                                               | 0.6995301 | 0.3004699 | 0.0000000 |
| Slovakia                                             | 0.5994131 | 0.4005869 | 0.0000000 |
| Estonia                                              | 0.5931944 | 0.4068056 | 0.0000000 |
| Finland                                              | 0.0000000 | 1.0000000 | 0.0000000 |
| Slovenia                                             | 0.0000000 | 1.0000000 | 0.0000000 |

Úgyhogy hagyjuk el ezeket is:

``` r
RawData <- RawData[!List%in%c("103", "10M")]
```

Így már csak egy kód marad, minden 104-es.

Dobjuk ki az életkori bontás nélküli országokat/éveket (a többit nem,
azokat megmentjük):

``` r
RawData <- RawData[Frmat != 9]
```

Van összesen 50313 életkorhoz nem rendelt halálozás, de ezek aránya
egyetlen országnál sem éri el még az 1 ezreléket sem:

``` r
knitr::kable(RawData[, .(sum(Deaths26)/sum(Deaths1)*1000), .(CountryName)][order(V1)])
```

| CountryName                                          |        V1 |
|:-----------------------------------------------------|----------:|
| Austria                                              | 0.0000000 |
| Bulgaria                                             | 0.0000000 |
| Czechia                                              | 0.0000000 |
| Denmark                                              | 0.0000000 |
| France                                               | 0.0000000 |
| Germany                                              | 0.0000000 |
| Iceland                                              | 0.0000000 |
| Ireland                                              | 0.0000000 |
| Luxembourg                                           | 0.0000000 |
| Netherlands (Kingdom of the)                         | 0.0000000 |
| Norway                                               | 0.0000000 |
| Poland                                               | 0.0000000 |
| Slovakia                                             | 0.0000000 |
| Spain                                                | 0.0000000 |
| Switzerland                                          | 0.0000000 |
| United Kingdom, England and Wales                    | 0.0000000 |
| United Kingdom, Northern Ireland                     | 0.0000000 |
| United Kingdom of Great Britain and Northern Ireland | 0.0005076 |
| Belgium                                              | 0.0035713 |
| United Kingdom, Scotland                             | 0.0063882 |
| Canada                                               | 0.0083651 |
| Chile                                                | 0.0088247 |
| Sweden                                               | 0.0167316 |
| Lithuania                                            | 0.0259116 |
| Israel                                               | 0.0486159 |
| Italy                                                | 0.0496807 |
| Latvia                                               | 0.0500928 |
| United States of America                             | 0.0806173 |
| Australia                                            | 0.0826013 |
| Hungary                                              | 0.0894482 |
| Belarus                                              | 0.0916262 |
| Greece                                               | 0.1040738 |
| Republic of Korea                                    | 0.1376767 |
| Portugal                                             | 0.1486109 |
| Estonia                                              | 0.1538646 |
| Croatia                                              | 0.2548436 |
| New Zealand                                          | 0.4215682 |
| Japan                                                | 0.5290881 |
| China, Hong Kong Special Administrative Region       | 0.8052753 |

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

Ugyanez a helyzet a `Deaths3`-mal, ami a 2-es formátumnál jelent mást.
Itt viszont az összevont kategóriát az összesnél elmentjük, de ennek
teljesen más oka van (a referencia-populáció is csak az összevont
életkori kategóriát fogja tartalmazni):

``` r
RawData$Deaths3456 <- ifelse(RawData$Frmat == 2, RawData$Deaths3,
                             RawData$Deaths3 + RawData$Deaths4 + RawData$Deaths5 +
                               RawData$Deaths6)
```

Ezt követően beállítjuk a `Deaths3` értékét is:

``` r
RawData$Deaths3 <- ifelse(RawData$Frmat == 2, NA, RawData$Deaths3)
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

Még egy előkészítő lépést teszünk. A W00-Y34 kódok kilenc kivételtől
eltekintve (W26, X34, X47, X59, X67, X88, Y06, Y07, Y17) nincsenek
alábontva három karakteren túl, ennek ellenére néhol szerepel az
adatbázisban negyedik karakter is. Ennek az az oka, hogy a kód-kézikönyv
megengedi ezekben az esetekben egy ún. „előfordulás helye” kód
alkalmazását (0: otthon, 1: bentlakásos intézmény stb.); ez kerülhet a
4. karakter pozíciójába. Mivel ennek az alkalmazása nem egységes (van
ország, ami ilyen kódra is jelentett eseményt, de az alábontás nélküli,
három karakteresre is – noha a 9-es kód az, hogy nem meghatározott
helyen), ráadásul elvileg itt egy tevékenység-kód is szerepelhet, ami
azt adja meg, hogy milyen tevékenység közben következett be az esemény,
így ezeket most össze fogjuk vonni (magyarán eldobjuk ezeket a további
információkat). Ez tudatos információvesztés, bár vélhetően szinte nulla
jelentőségű; ha valakinek mégis kellene ez, akkor a nyers adatbázisból
természetesen kiolvasható. Az átalakítás:

``` r
RawData[substring(Cause, 1, 1) == "W"]$Cause <-
  substring(RawData[substring(Cause, 1, 1) == "W"]$Cause, 1, 3)
RawData[substring(Cause, 1, 1) == "X"]$Cause <-
  substring(RawData[substring(Cause, 1, 1) == "X"]$Cause, 1, 3)
RawData[(substring(Cause, 1, 1) == "Y")][
  (as.numeric(substring(Cause, 2, 3)) <= 34) &
    (!as.numeric(substring(Cause, 2, 3)) %in% c(6, 7))]$Cause <-
  substring(RawData[(substring(Cause, 1, 1) == "Y")][
    (as.numeric(substring(Cause, 2, 3)) <= 34) &
      (!as.numeric(substring(Cause, 2, 3)) %in% c(6, 7))]$Cause, 1, 3)
```

(Mint látható, a kilenc kivételből hétnél mégis összevontam az adatokat,
csak kettőnél – Y06 és Y07 – nem. Ennek az az oka, hogy nagyon úgy
tűnik, hogy a maradék hétnél, hiába is van hivatalos alábontás, nem azt
használták, hanem az előfordulás helye kódot, ugyanis megjelennek
ezeknél olyan negyedik számjegyek, amik a hivatalos alábontás szerint
nem is létezhetnének – viszont az előfordulás helye szerint igen.
Akárhogy is, ez nem volt egyértelműen beazonosítható, úgyhogy a
háromkarakteres főcsoportra redukáltam őket, ami viszont már az.)

Természetesen nem elég pusztán a kódokat összevonni, hiszen így
duplikátumok keletkeznek a sorokban, amiket szintén össze kell vonni,
szummázással:

``` r
RawData <- RawData[, .(value = sum(value)), .(iso3c, Year, Cause, Sex, Frmat, Age)]
```

A WHO adatbázisában a BNO-kódok annak ellenére sem mind 4 jegyűek, hogy
már leszűkítettük magunkat csak a 104-es formátumra. Ennek az az oka,
hogy amelyik kódnál nincs alábontás, tehát nem is szerepel 4 jegyű
kategória alatta, ott a kód három karakterrel szerepel. (Sajnos ez nem
konzisztens, de erről majd később, a BNO-kódoknál.) A magyar szokás
azonban az, hogy a kódok mindenképp 5 jegyűek legyenek, ezért a 4
jegyűek végére „0”-t, a 3 jegyűek végére „H0”-t kell fűzni a hazai
konvenció szerint; tegyük ezt most meg, hogy később össze tudjuk
kapcsolni a WHO-s mortalitási táblákat a magyar BNO táblával:

``` r
RawData[nchar(Cause) == 3]$Cause <- paste0(RawData[nchar(Cause) == 3]$Cause, "H0")
RawData[nchar(Cause) == 4]$Cause <- paste0(RawData[nchar(Cause) == 4]$Cause, "0")
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
országban és adott évben halálozás, akkor nem 0-val fog szerepelni az
adott BNO, hanem egyszerűen nem lesz benne a BNO a kérdéses országban és
évnél. Az életkor azért kivétel, mert az külön oszlopokban van az
eredeti táblában, így ott a 0-k is mindenképp ki vannak írva.) Ennek a
későbbi kezeléséhez szükségünk lesz országonként és évenként az összes
nem és életkor kombinációjára:

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
CountryCodes <- CountryCodes[ISO%in%unique(RawData$iso3c) & !ISO%in%c("X10", "X11", "X12"),
                             .(iso3c = ISO, Country = countries::country_name(DisplayString,
                                                                              to = "name_hu"))]
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
figyelve a jó kódolásra:

``` r
ICDData <- data.table(foreign::read.dbf("./inputdata/BNOTORZS.DBF", as.is = TRUE))
ICDData$NEV <- stringi::stri_encode(ICDData$NEV, "windows-852", "UTF-8")
```

Ebben vannak már nem érvényes kódok is, szerencsére ezek az `ERV_VEGE`
nevű változó alapján könnyen azonosíthatóak:

``` r
ICDData <- ICDData[ERV_VEGE=="29991231"]
```

Ahogy már korábban is említettem, ebben a táblában minden BNO-kód
pontosan 5 karakter, elvileg tehát illeszthető a WHO-s táblával (a fenti
átalakításaink után). A gyakorlatban azonban sajnos lesznek olyan kódok,
amik a WHO-táblában szerepelnek, de a magyar BNO-törzsben mégsem. Nézzük
meg, hogy mik ezek:

``` r
unique(merge(RawData, ICDData[, .(Cause = KOD10, Nev = NEV)], all.x = TRUE)[is.na(Nev)]$Cause)
```

    ##   [1] "A0900" "A0990" "A16H0" "A9700" "A9710" "A9720" "A9790" "B07H0" "B1790"
    ##  [10] "B3340" "B4850" "B9800" "B9810" "C22H0" "C25H0" "C34H0" "C43H0" "C45H0"
    ##  [19] "C57H0" "C71H0" "C7990" "C8000" "C8090" "C8140" "C8230" "C8240" "C8250"
    ##  [28] "C8260" "C8460" "C8470" "C8480" "C8490" "C8520" "C8600" "C8610" "C8620"
    ##  [37] "C8630" "C8640" "C8650" "C8660" "C8840" "C9030" "C9160" "C9180" "C9260"
    ##  [46] "C9280" "C9330" "C9460" "C94H0" "C9640" "C9650" "C9660" "C9680" "D1640"
    ##  [55] "D4650" "D4660" "D4740" "D4750" "D66H0" "D67H0" "D6850" "D6860" "D8930"
    ##  [64] "E11H0" "E14H0" "E1640" "E43H0" "E78H0" "E85H0" "E8830" "F05H0" "F10H0"
    ##  [73] "F73H0" "G14H0" "G2140" "G2330" "G30H0" "G40H0" "G80H0" "G8350" "G8360"
    ##  [82] "G9040" "G9050" "G9060" "G9070" "G90H0" "G91H0" "G93H0" "H5490" "I11H0"
    ##  [91] "I12H0" "I21H0" "I25H0" "I26H0" "I2720" "I40H0" "I4800" "I4810" "I4820"
    ## [100] "I4830" "I4840" "I4890" "I49H0" "I51H0" "I60H0" "I63H0" "I70H0" "I71H0"
    ## [109] "I7250" "I7260" "I80H0" "J09H0" "J1230" "J15H0" "J18H0" "J20H0" "J2110"
    ## [118] "J44H0" "J65H0" "J80H0" "J9870" "K0250" "K1230" "K2270" "K25H0" "K3170"
    ## [127] "K31H0" "K3520" "K3530" "K3580" "K35H0" "K4320" "K4330" "K4340" "K4350"
    ## [136] "K4360" "K4370" "K5230" "K5530" "K55H0" "K5810" "K5820" "K5880" "K58H0"
    ## [145] "K6350" "K6400" "K6410" "K6420" "K6430" "K6440" "K6450" "K6480" "K6490"
    ## [154] "K6620" "K70H0" "K7540" "K8340" "K8500" "K8510" "K8520" "K8530" "K8580"
    ## [163] "K8590" "K92H0" "L00H0" "L26H0" "L8900" "L8910" "L8920" "L8930" "L8990"
    ## [172] "L9870" "M3170" "M4590" "M7260" "M7970" "N1810" "N1820" "N1830" "N1840"
    ## [181] "N1850" "N40H0" "N4230" "N47H0" "N62H0" "O1420" "O4320" "O6000" "O6010"
    ## [190] "O6030" "O9600" "O9610" "O9690" "O9700" "O9710" "O9790" "O9870" "P9160"
    ## [199] "P9170" "Q21H0" "Q3150" "R0030" "R09H0" "R1700" "R1790" "R2630" "R2960"
    ## [208] "R5020" "R5080" "R6360" "R6520" "R6530" "R6590" "R9500" "R9590" "U0490"
    ## [217] "U0700" "U0990" "U1090" "U1290" "V03H0" "V04H0" "V05H0" "V12H0" "V13H0"
    ## [226] "W46H0" "Y06H0" "Y07H0" "Y60H0" "Y63H0" "Y7000" "Y7010" "Y7020" "Y7030"
    ## [235] "Y7080" "Y7100" "Y7110" "Y7120" "Y7130" "Y7180" "Y7200" "Y7210" "Y7220"
    ## [244] "Y7230" "Y7280" "Y7300" "Y7310" "Y7320" "Y7330" "Y7380" "Y7400" "Y7410"
    ## [253] "Y7420" "Y7430" "Y7480" "Y7500" "Y7510" "Y7520" "Y7530" "Y7580" "Y7610"
    ## [262] "Y7620" "Y7630" "Y7680" "Y7700" "Y7720" "Y7800" "Y7810" "Y7820" "Y7880"
    ## [271] "Y7900" "Y7910" "Y7920" "Y7930" "Y7980" "Y8000" "Y8010" "Y8020" "Y8080"
    ## [280] "Y8100" "Y8110" "Y8120" "Y8130" "Y8180" "Y8200" "Y8210" "Y8220" "Y8230"
    ## [289] "Y8280" "Y85H0" "Y88H0"

Végignézve ezeket a kódokat, a következő problémák azonosíthatóak:

- A magyar BNO-tábla néha nem tartalmazza az alábontásokat (és H0
  végződést alkalmaz helyettük), pedig léteznek. Ilyen az A09, amiből
  csak A09H0 van a magyar táblában, holott a WHO-nál két alábontás is
  van, az A090 és az A099. További példa ilyenre a C80, I48, K85, L89,
  O60, O96, O97, R17, R95, Y70, Y71, Y72, Y73, Y74, Y75, Y76, Y77, Y78,
  Y79, Y80, Y81, Y82.
- A WHO nem alkalmazza konzisztensen az „ahol nincs alábontás, ott 3
  karakter van, ahol van, ott 4” szabályt. Ilyen például az A16, aminek
  egy egész sor alkategóriája van, mégis szerepel önmagában az A16 is.
  (Ami a fenti konverzióval A16H0-ba fog menni, csakhogy ilyet nem
  talál, mert a magyar törzsben – immár helyesen – csak az alábontott
  kódok szerepelnek.) Talán arról lehet szó, hogy vannak országok, amik
  nem használnak finom felbontást, bár az furcsa, hogy ez hogyan fér
  össze a 104-es kóddal, ami pont azt jelenti, hogy ahol van, ott 4
  jegyet kell használni. További példa ilyenre a C22, C25, C34, C43,
  C45, C57, C71, C94, E11, E14, E78, E85, F05, F10, F73, G30, G40, G80,
  G90, G91, G93, I11, I12, I21, I25, I26, I40, I49, I51, I60, I63, I70,
  I71, I80, J15, J18, J20, J44, K25, K31, K35, K55, K58, K70, K92, L00,
  N47, Q21, R09, V03, V04, V05, V12, V13, Y06, Y07, Y60, Y63, Y85, Y88.
- Azok az esetek, ahol a magyar rendszer elhasználja az 5. karaktert is
  valamilyen alábontásra, szintén zavart okoznak. Ilyen a B07, ami a
  WHO-nál – alábontás nélküli – „vírusos szemölcsök”, csakhogy a magyar
  törzs bevezett egy alkategóriát (B0701) arra, hogy „vírusos szemölcsök
  talpi lokalizációban 10 db felett”. Ezzel nincs is gond, a probléma
  az, hogy emiatt az eredeti kategória B0700 kódot kapott, holott
  logikusabb lenne a B07H0 (és a fenti mechanizmus is ezt fogja keresni,
  hiszen a WHO-nál csak a háromjegyű B07 van meg). További példa ilyenre
  a D66, D67, E43, L26, N40, N62.
- Az előző egy alfaja, amikor a magyar rendszerben csak az öt jegyű
  alábontás szerepel, a négyjegyzű kategória nem is. Erre példa a D164,
  ami az arc- és agykoponya csontjainak jóindulatú daganata a WHO-nál,
  de a magyar rendszerben D1640 nincs, csak D1641 (agykoponya
  csontjainak jóindulatú daganata) és D1642 (arckoponya csontjainak
  jóindúlatú daganata). További példa ilyenre a K834.
- A legbizarrabb példa az A97. Ez a WHO táblája szerint a Dengue-láz,
  tehát nem is egy nagyon speciális egzotikum, miközben a magyar
  BNO-törzsben ilyen kód *nem is szerepel*… Hogy végképp teljes legyen a
  zavar, a Dengue-láz valójában *benne van* a magyar BNO-törzsben, csak
  épp A90-es kóddal – ami viszont a hivatalos WHO-törzsben nem létezik!
  Hasonlóképp komplettül hiányzik a B98, C86, G14, J09, K64, R65, W46.
- Az előbbi enyhébb esete, amikor egy alábontás hiányzik: a B17-ből a
  WHO-nál B170, B171, B172, B178 és B179 van, de a magyar táblából egész
  egyszerűen hiányzik a B179! Nem mindig a 9-essel (k.m.n) van a baj, a
  B33-nál a B334 hiányzik a magyar táblából (holott a WHO-nál megvan).
  További példa ilyenre a B485, C799, C814, C823, C824, C825, C826,
  C846, C847, C848, C849, C852, C884, C903, C916, C918, C926, C928,
  C933, C946, C964, C965, C966, C968, D465, D466, D474, D475, D685,
  D686, D893, E164, E883, G214, G233, G835, G836, G04, G905, G906, G907,
  H549, I272, I725, I726, J123, J211, J987, K025, K123, K227, K317,
  K352, K353, K358, K432, K433, K434, K435, K436, K437, K523, K553,
  K581, K582, K588, K635, K662, K754, L987, M317, M459, M726, M797,
  N181, N182, N183, N184, N185, N423, O142, O432, O987, P916, P917,
  Q315, R003, R263, R296, R502, R508, R636.
- Érdekes módon van példa az ellentétére is: amikor a magyar tábla
  szerint van lebontás, de a WHO-nál valójában nincs, ilyen a J65. (A
  dolog azért gond, mert a lebontás léte miatt hiányozni fog a J65H0,
  holott a valóságban ez lesz az egyetlen kód itt.) További példa
  ilyenre a J80.
- Az U kódok az ún. „különleges célú kódok”; itt valószínűleg nem
  hibáztatható a magyar tábla, hogy ezeket nem tartalmazza (a WHO-é
  sem). Öt ilyen fordult elő: U049, U070, U099, U109, U129

Jó lenne kideríteni, hogy a fentieknek mi az oka!

Jobb híján ezeket úgy javítottam, hogy hozzáadtam a magyar táblához a
hiányzó kódokat, névként megadva a kódot (hiszen nevem nincsen, pont ez
a probléma, de így nem fogunk adatot veszíteni – az ilyen kódoknál
névként is a kód fog megjelenni):

``` r
ICDData <- rbind(ICDData, data.table(
  KOD10 = unique(merge(RawData, ICDData[, .(Cause = KOD10, Nev = NEV)],
                       all.x = TRUE)[is.na(Nev)]$Cause),
  JEL = NA, NEV = unique(merge(RawData, ICDData[, .(Cause = KOD10, Nev = NEV)],
                               all.x = TRUE)[is.na(Nev)]$Cause),
  NEM = 0, KOR_A = 0, KOR_F = 99, ERV_KEZD = "19950101", ERV_VEGE = "29991231"))
```

A későbbi feldolgozhatóság kedvéért az 1. karaktert és a 2-3. számot
mentsük ki külön, ez utóbbit tényleges számmá is alakítva:

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

![](README_files/figure-gfm/unnamed-chunk-44-1.png)<!-- -->

``` r
plot(log(`+`) ~ log(`-`), data = dcast(PopData[YearSign!=""], iso3c + Age + Year ~ YearSign, value.var = "Total"))
abline(0, 1)
```

![](README_files/figure-gfm/unnamed-chunk-44-2.png)<!-- -->

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

    ## Table demo_pjan cached at C:\Users\FERENC~1\AppData\Local\Temp\RtmpuUrLrt/eurostat/e6aeea1a90a31eacc207ffa74df198c3.rds

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

![](README_files/figure-gfm/unnamed-chunk-45-1.png)<!-- -->

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

Az oldal forráskódja letölhető innen:
[app.R](https://github.com/tamas-ferenci/OkspecifikusMortalitasiAdatbazis/blob/main/app.R).

## Továbbfejlesztési lehetőségek

- [ ] 103-as (és esetleg egyéb) BNO-kódolási rendszerek bekapcsolása.
- [ ] Az 1995 előtti korábbi BNO-k bekapcsolása.
