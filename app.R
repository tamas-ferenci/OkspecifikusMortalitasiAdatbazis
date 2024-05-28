library(shiny)
library(data.table)
library(highcharter)

hcoptslang <- getOption("highcharter.lang")
hcoptslang$contextButtonTitle <- "Helyi menü"
hcoptslang$exitFullscreen <- "Kilépés a teljes képernyős módból"
hcoptslang$hideData <- "Adatok elrejtése"
hcoptslang$loading <- "Betöltés..."
hcoptslang$mainBreadcrumb <- "Fő ábra"
hcoptslang$noData <- "Nincs megjeleníthető adat"
hcoptslang$printChart <- "Ábra nyomtatása"
hcoptslang$viewData <- "Adatok megtekintése"
hcoptslang$viewFullscreen <- "Teljes képernyős nézet"
hcoptslang$months <- c("január", "február", "március", "április", "május","június", "július",
                       "augusztus", "szeptember", "október", "november", "december")
hcoptslang$shortMonths <- c("jan", "febr", "márc", "ápr", "máj", "jún", "júl", "aug", "szept",
                            "okt", "nov", "dec")
hcoptslang$weekdays <- c("vasárnap", "hétfő", "kedd", "szerda", "csütörtök", "péntek",
                         "szombat")
hcoptslang$shortWeekdays <- c("Vas", "Hét", "Ked", "Sze", "Csü", "Pén", "Szo", "Vas")
hcoptslang$exportButtonTitle <- "Exportál"
hcoptslang$printButtonTitle <- "Importál"
hcoptslang$rangeSelectorFrom <- "ettől"
hcoptslang$rangeSelectorTo <- "eddig"
hcoptslang$rangeSelectorZoom <- "mutat:"
hcoptslang$downloadPNG <- "Letöltés PNG képként"
hcoptslang$downloadJPEG <- "Letöltés JPEG képként"
hcoptslang$downloadPDF <- "Letöltés PDF dokumentumként"
hcoptslang$downloadSVG <- "Letöltés SVG formátumban"
hcoptslang$downloadCSV <- "Letöltés CSV formátumú táblázatként"
hcoptslang$downloadXLS <- "Letöltés XLS formátumú táblázatként"
hcoptslang$resetZoom <- "Nagyítás alaphelyzetbe állítása"
hcoptslang$resetZoomTitle <- "Nagyítás alaphelyzetbe állítása"
hcoptslang$thousandsSep <- " "
hcoptslang$decimalPoint <- ","
hcoptslang$numericSymbols <- NA
options(highcharter.lang = hcoptslang)
options(highcharter.download_map_data = FALSE)

RawData <- arrow::read_feather("WHO-MDB.feather")

RawDataAll <- readRDS("RawDataAll.rds")

PopData <- readRDS("WHO-MDB-Population.rds")

AgeTable <- data.table(Age = c(NA, paste0("Deaths", 2:25), "Deaths3456", "Deaths232425"),
                       AgeNum = c(NA, (0:4) + 0.5, seq(5, 90, 5) + 2.5, 100, 3, 95),
                       AgeLabel = c(NA, c(0:4, paste0(seq(5, 95, 5), "-",
                                                      c(seq(9, 94, 5), "")), "1-4", "85-")))

PopData <- merge(PopData, AgeTable, by = "Age")

ICDGroups <- readRDS("ICDGroups.rds")
ICDmulti <- sapply(ICDGroups, length) > 1
stratsel <- c("Nincs" = "None", "Nem szerint" = "Sex", "Életkor szerint" = "AgeLabel")
StdPop <- fread("ESP2013.csv", dec = ",")
StdPop$Frmat <- as.factor(StdPop$Frmat)

CountryCodes <- readRDS("CountryCodes.rds")

EUCountries <- list(
  "EU27" = countrycode::countrycode(eurostat::eu_countries$code, "eurostat", "iso3c"),
  "EU15" = c("AUT", "BEL", "DNK", "FIN", "FRA", "DEU", "GRC", "IRL", "ITA", "LUX", "NLD", "PRT",
             "ESP", "SWE", "GBR"),
  "EU11" = c("CZE", "EST", "HUN", "LVA", "LTU", "POL", "SVK", "SVN", "BGR", "ROU", "HRV"),
  "V4" = c("SVK", "CZE", "HUN", "POL")
)

dimredvizData <- readRDS("dimredvizData.rds")

desctext <- paste0("Hazai és nemzetközi halálozási adatok, halálokok vizsgálatát,",
                   "összehasonlítását lehetővé tevő alkalmazás. Írta: Ferenci Tamás.")
urlpre <- "https://research.physcon.uni-obuda.hu/"

# ICDlabel <- div("Kiválasztott betegség(ek)", bslib::tooltip(
#   bsicons::bs_icon("question-circle"),
#   "Backspace-szel, Del-lel törölhető a kiválasztott, gépelve név szerint kereshető.",
#   placement = "right"))

pickeropts <- shinyWidgets::pickerOptions(
  actionsBox = TRUE,
  liveSearch = TRUE,
  noneSelectedText = "Válasszon!",
  noneResultsText = "Nincs találat {0}",
  countSelectedText = "{0} elem kiválasztva",
  maxOptionsText ="Legfeljebb {n} elem választható",
  selectAllText = "Mindegyik",
  deselectAllText = "Egyik sem",
  multipleSeparator = ", ",
  style = "btn btn-outline-dark"
)

pickeroptsWOSearch <- shinyWidgets::pickerOptions(
  actionsBox = TRUE,
  liveSearch = FALSE,
  noneSelectedText = "Válasszon!",
  noneResultsText = "Nincs találat {0}",
  countSelectedText = "{0} elem kiválasztva",
  maxOptionsText ="Legfeljebb {n} elem választható",
  selectAllText = "Mindegyik",
  deselectAllText = "Egyik sem",
  multipleSeparator = ", ",
  style = "btn btn-outline-dark"
)

metrictext <- HTML(paste0(
  "Az <b>abszolút szám</b> a halálozások száma főben, így országok közötti összehasonlításra ",
  "nem alkalmas. A <b >nyers ráta</b> az abszolút szám osztva az ország lélekszámával, így ",
  "jobban összehasonlítható, de az eltérő korfát ez sem veszi figyelembe. A ",
  "<b>standardizált ráta</b> korrigál az eltérő korösszetételre is."))

ui <- navbarPage(
  theme = bslib::bs_theme(bootswatch = "default"),
  title = "Okspecifikus Mortalitási Adatbázis",
  # title = h4(HTML("Okspecifikus Mortalitási Adatbázis<br>Ferenci Tamás, medstat.hu")),
  # title = div(p("test title", br(), "kettp"), class = "test"),
  header = list(
    tags$head(
      tags$meta(name = "description", content = desctext),
      tags$meta(property = "og:title", content = "Okspecifikus Mortalitási Adatbázis"),
      tags$meta(property = "og:type", content = "website"),
      tags$meta(property = "og:locale", content = "hu_HU"),
      tags$meta(property = "og:url", content = paste0(urlpre, "OkspecifikusMortalitasiAdatbazis/")),
      tags$meta(property = "og:image", content = paste0(urlpre, "OkspecifikusMortalitasiAdatbazis-Pelda.png")),
      tags$meta(property = "og:image:width", content = 1200),
      tags$meta(property = "og:image:height", content = 630),
      tags$meta(property = "og:description", content = desctext),
      tags$meta(name = "DC.Title", content = "Okspecifikus Mortalitási Adatbázis"),
      tags$meta(name = "DC.Creator", content = "Ferenci Tamás"),
      tags$meta(name = "DC.Subject", content = "népegészségtan"),
      tags$meta(name = "DC.Description", content = desctext),
      tags$meta(name = "DC.Publisher", content = paste0(urlpre, "OkspecifikusMortalitasiAdatbazis/")),
      tags$meta(name = "DC.Contributor", content = "Ferenci Tamás"),
      tags$meta(name = "DC.Language", content = "hu_HU"),
      tags$meta(name = "twitter:card", content = "summary_large_image"),
      tags$meta(name = "twitter:title", content = "Okspecifikus Mortalitási Adatbázis"),
      tags$meta(name = "twitter:description", content = desctext),
      tags$meta(name = "twitter:image", content = paste0(urlpre, "OkspecifikusMortalitasiAdatbazis-Pelda.png"))
    ),
    
    tags$script(src = "https://code.highcharts.com/mapdata/custom/world.js"),
    tags$script(src = "https://code.highcharts.com/mapdata/custom/europe.js"),
    
    tags$div(id = "fb-root"),
    tags$script(async = NA, defer = NA, crossorigin = "anonymous",
                src = "https://connect.facebook.net/hu_HU/sdk.js#xfbml=1&version=v19.0",
                nonce = "mr8Yvh3Y"),
    
    p("A program használatát részletesen bemutató súgó, valamint a technikai részletek",
      a("itt", href = "https://github.com/tamas-ferenci/OkspecifikusMortalitasiAdatbazis",
        target = "_blank" ), "olvashatóak el."),
    
    div(style = "line-height: 13px;",
        div(class = "fb-share-button",
            "data-href" = "https://research.physcon.uni-obuda.hu/OkspecifikusMortalitasiAdatbazis",
            "data-layout" = "button_count", "data-size" = "small",
            a("Megosztás", target = "_blank",
              href = paste0("https://www.facebook.com/sharer/sharer.php?u=",
                            "https%3A%2F%2Fresearch.physcon.uni-obuda.hu%2FOkspecifikusMortalitasiAdatbazis&amp;src=sdkpreparse"),
              class = "fb-xfbml-parse-ignore")),
        
        a("Tweet", href = "https://twitter.com/share?ref_src=twsrc%5Etfw",
          class = "twitter-share-button", "data-show-count" = "true"),
        includeScript("http://platform.twitter.com/widgets.js", async = NA, charset = "utf-8"))),
  footer = list(
    hr(),
    p("Írta: ", a("Ferenci Tamás", href = "http://www.medstat.hu/", target = "_blank",
                  .noWS = "outside"), ", v0.26"),
    
    tags$script(HTML("
      var sc_project=11601191; 
      var sc_invisible=1; 
      var sc_security=\"5a06c22d\";
                     "),
                type = "text/javascript"),
    tags$script(type = "text/javascript", src = "https://www.statcounter.com/counter/counter.js",
                async = NA),
    tags$noscript(div(class = "statcounter",
                      a(title = "ingyen webstatisztika", href = "https://www.statcounter.hu/",
                        target = "_blank",
                        img(class = "statcounter",
                            src = "https://c.statcounter.com/11601191/0/5a06c22d/1/",
                            alt = "ingyen webstatisztika",
                            referrerPolicy = "no-referrer-when-downgrade"))))
  ),
  
  tabPanel(
    title = "Időbeli trendek",
    sidebarLayout(
      sidebarPanel(
        conditionalPanel("input.timeMultipleICD == 'Single'",
                         shinyWidgets::pickerInput("timeICDSingle", "Kiválasztott betegség",
                                                   list(`Főbb csoportok` = names(ICDGroups[ICDmulti]),
                                                        `Elemi kódok` = names(ICDGroups[!ICDmulti])),
                                                   "Összes halálok (A00-Y89)",
                                                   multiple = FALSE,
                                                   options = pickeropts)),
        conditionalPanel("input.timeMultipleICD != 'Single'",
                         shinyWidgets::pickerInput("timeICDMultiple", "Kiválasztott betegségek",
                                                   list(`Főbb csoportok` = names(ICDGroups[ICDmulti]),
                                                        `Elemi kódok` = names(ICDGroups[!ICDmulti])),
                                                   "Összes halálok (A00-Y89)",
                                                   multiple = TRUE,
                                                   options = pickeropts)),
        radioButtons("timeMultipleICD", "Ábrázolt betegségek száma",
                     c("Egy betegség" = "Single",
                       "Több betegség, külön-külön ábrázolva" = "MultiIndiv",
                       "Több betegség, az összegük ábrázolva" = "MultiSum")),
        conditionalPanel("(input.timeMultipleICD != 'MultiIndiv')",
                         radioButtons("timeMultipleCountry", "Ábrázolt országok száma",
                                      c("Egy ország" = "Single", "Több ország" = "Multiple"))),
        conditionalPanel("(input.timeMultipleICD == 'MultiIndiv')|(input.timeMultipleCountry == 'Single')",
                         shinyWidgets::pickerInput("timeCountrySingle", "Ország",
                                                   CountryCodes, "HUN", FALSE,
                                                   options = pickeropts)),
        conditionalPanel("(input.timeMultipleICD != 'MultiIndiv')&(input.timeMultipleCountry == 'Multiple')",
                         shinyWidgets::pickerInput("timeCountryMultiple", "Ország",
                                                   CountryCodes, "HUN", TRUE,
                                                   options = pickeropts)),
        shinyWidgets::pickerInput("timeMetric", div("Ábrázolt mutató", bslib::tooltip(
          bsicons::bs_icon("question-circle"), metrictext, placement = "right")),
          c("Abszolút szám" = "count", "Nyers ráta" = "cruderate",
            "Standardizált ráta" = "adjrate"), "adjrate", options = pickeroptsWOSearch),
        conditionalPanel("input.timeMultipleICD != 'MultiIndiv' & input.timeMultipleCountry == 'Single'",
                         radioButtons("timeStratification", "Lebontás", stratsel)),
        checkboxInput("timeLogY", "A függőleges tengely logaritmikus"),
        checkboxInput("timeYFromZero", "A függőleges tengely nullától indul")
      ),
      
      mainPanel(
        shinycssloaders::withSpinner(highchartOutput("timePlot", height = "600px"))
      )
    )
  ),
  tabPanel(title = "Területi összehasonlítás",
           sidebarLayout(
             sidebarPanel(
               shinyWidgets::pickerInput("mapICDSingle", "Kiválasztott betegség",
                                         list(`Főbb csoportok` = names(ICDGroups[ICDmulti]),
                                              `Elemi kódok` = names(ICDGroups[!ICDmulti])),
                                         "Összes halálok (A00-Y89)",
                                         multiple = FALSE,
                                         options = pickeropts),
               shinyWidgets::pickerInput("mapMetric", div("Ábrázolt mutató", bslib::tooltip(
                 bsicons::bs_icon("question-circle"), metrictext, placement = "right")),
                 c("Abszolút szám" = "count", "Nyers ráta" = "cruderate",
                   "Standardizált ráta" = "adjrate"), "adjrate", options = pickeroptsWOSearch),
               radioButtons("mapType", "Ábrázolás módja",
                            c("Térkép" = "Map", "Oszlopdiagram" = "Bar")),
               conditionalPanel("input.mapType == 'Map'",
                                shinyWidgets::pickerInput("mapMap", "Térkép",
                                                          c("Európa" = "europe", "Világ" = "world"),
                                                          options = pickeroptsWOSearch)),
               shinyWidgets::pickerInput("mapSex", "Ábrázolt nem", c("Összesen", "Férfi", "Nő"),
                                         options = pickeroptsWOSearch),
               conditionalPanel("input.mapMetric != 'adjrate'",
                                shinyWidgets::pickerInput("mapAge", "Ábrázolt életkor",
                                                          setNames(c("Összesen", AgeTable[!is.na(Age)][order(AgeNum)]$Age),
                                                                   c("Összesen", AgeTable[!is.na(Age)][order(AgeNum)]$AgeLabel)),
                                                          options = pickeroptsWOSearch)),
               conditionalPanel("input.mapType == 'Bar'",
                                checkboxInput("mapBarOrder", "Nagyság szerint sorbarendezve"))
             ),
             
             mainPanel(
               shinycssloaders::withSpinner(highchartOutput("mapPlot", height = "600px")),
               tags$style(type = "text/css", ".irs-grid-pol.small {height: 0px;}"),
               sliderInput("mapYear", div("Vizsgált év(tartomány)", bslib::tooltip(
                 bsicons::bs_icon("question-circle"),
                 paste0("Amennyiben a csúszka két vége nem esik egybe, úgy a megjelenített ",
                        "adat a tartomány összesített eredménye. A két végpont egy évre is ",
                        "összehúzható, ez esetben a kérdéses év adata fog látszódni."),
                 placement = "right")), min(RawData$Year), max(RawData$Year),
                 c(2020, 2022), 1, sep = "", width = "100%")
             )
           )
  ),
  tabPanel(
    title = "Életkor és nem hatása",
    sidebarLayout(
      sidebarPanel(
        conditionalPanel("input.agesexMultipleICD == 'Single'",
                         shinyWidgets::pickerInput("agesexICDSingle", "Kiválasztott betegség",
                                                   list(`Főbb csoportok` = names(ICDGroups[ICDmulti]),
                                                        `Elemi kódok` = names(ICDGroups[!ICDmulti])),
                                                   "Összes halálok (A00-Y89)",
                                                   multiple = FALSE,
                                                   options = pickeropts)),
        conditionalPanel("input.agesexMultipleICD != 'Single'",
                         shinyWidgets::pickerInput("agesexICDMultiple", "Kiválasztott betegségek",
                                                   list(`Főbb csoportok` = names(ICDGroups[ICDmulti]),
                                                        `Elemi kódok` = names(ICDGroups[!ICDmulti])),
                                                   "Összes halálok (A00-Y89)",
                                                   multiple = TRUE,
                                                   options = pickeropts)),
        radioButtons("agesexMultipleICD", "Ábrázolt betegségek száma",
                     c("Egy betegség" = "Single",
                       "Több betegség, külön-külön ábrázolva" = "MultiIndiv",
                       "Több betegség, az összegük ábrázolva" = "MultiSum")),
        conditionalPanel("(input.agesexMultipleICD != 'MultiIndiv')",
                         radioButtons("agesexMultipleCountry", "Ábrázolt országok száma",
                                      c("Egy ország" = "Single", "Több ország" = "Multiple"))),
        conditionalPanel("(input.agesexMultipleICD == 'MultiIndiv')|(input.agesexMultipleCountry == 'Single')",
                         shinyWidgets::pickerInput("agesexCountrySingle", "Ország",
                                                   CountryCodes, "HUN", FALSE,
                                                   options = pickeropts)),
        conditionalPanel("(input.agesexMultipleICD != 'MultiIndiv')&(input.agesexMultipleCountry == 'Multiple')",
                         shinyWidgets::pickerInput("agesexCountryMultiple", "Ország",
                                                   CountryCodes, "HUN", TRUE,
                                                   options = pickeropts)),
        conditionalPanel("(input.agesexMultipleICD != 'MultiIndiv') & (input.agesexMultipleCountry == 'Single')",
                         radioButtons("agesexStratification", "Lebontás", c("Nincs" = "None", "Nem szerint" = "Sex", "Év szerint" = "Year"))),
        checkboxInput("agesexLogY", "A függőleges tengely logaritmikus", TRUE),
        checkboxInput("agesexYFromZero", "A függőleges tengely nullától indul"),
      ),
      
      mainPanel(
        shinycssloaders::withSpinner(highchartOutput("agesexPlot", height = "600px"))
      )
    )
  ),
  navbarMenu("Speciális elemzések",
             tabPanel(
               title = "Magyarország és a világ",
               sidebarLayout(
                 sidebarPanel(
                   shinyWidgets::pickerInput("hunworldCountryMultiple",
                                             "Összehasonlítási alapot képező országok",
                                             CountryCodes[CountryCodes != "HUN"],
                                             setdiff(EUCountries$EU27, "HUN"), TRUE,
                                             options = pickeropts),
                   actionButton("hunworldEU27", "EU27 (Európai Unió) beállítása"),
                   actionButton("hunworldEU15", "EU15 ('Nyugat') beállítása"),
                   actionButton("hunworldEU11", "EU11 ('Kelet') beállítása"),
                   actionButton("hunworldV4", "V4 (visegrádi négyek) beállítása"),
                   checkboxInput("hunworldLog", "Logaritmikus ábra", FALSE),
                   checkboxInput("hunworldXRangeSet",
                                 "Vízszintes tengely tartományának beállítása", FALSE),
                   conditionalPanel("input.hunworldXRangeSet",
                                    sliderInput("hunworldXRange",
                                                "Vízszintes tengely tartománya",
                                                0, 2000, c(0, 100)))
                 ),
                 
                 mainPanel(
                   shinycssloaders::withSpinner(highchartOutput("hunworldPlot", height = "600px")),
                   tags$style(type = "text/css", ".irs-grid-pol.small {height: 0px;}"),
                   sliderInput("hunworldYear", div("Vizsgált év(tartomány)", bslib::tooltip(
                     bsicons::bs_icon("question-circle"),
                     paste0("Amennyiben a csúszka két vége nem esik egybe, úgy a megjelenített ",
                            "adat a tartomány összesített eredménye. A két végpont egy évre is ",
                            "összehúzható, ez esetben a kérdéses év adata fog látszódni."),
                     placement = "right")), min(RawData$Year), max(RawData$Year),
                     c(2020, 2022), 1, sep = "", width = "100%")
                 )
               )
             ),
             tabPanel(
               title = "Vizualizáció dimenziócsökkentéssel",
               sidebarLayout(
                 sidebarPanel(
                   shinyWidgets::pickerInput("dimredvizMethod",
                                             "Alkalmazott módszer",
                                             c("PCA", "MDS", "t-SNE"), "t-SNE", FALSE,
                                             options = pickeropts),
                 ),
                 
                 mainPanel(
                   shinycssloaders::withSpinner(highchartOutput("dimredvizPlot", height = "600px"))
                 )
               )
             )
  )
)

server <- function(input, output) {
  
  observeEvent("", {
    showModal(modalDialog(
      h1("Okspecifikus Mortalitási Adatbázis"),
      p(paste0("Ez a weboldal a magyar halálozási adatokat tartalmazza halálok, nem és ",
               "életkor szerinti lebontásban, évente, 1995-ig visszamenően, valamint lehetővé ",
               "teszi ezek számos vetületben történő elemzését, vizualizálását és nemzetközi ",
               "összehasonlítását.")),
      p(paste0("Az adatok értelmezése, az adatminőség, a különféle összehasonlítások nem ",
               "nyilvánvaló problémákat vetnek fel, így érdemes bármilyen következtetés ",
               "levonása előtt tanulmányozni az oldalhoz kapcsolódó "),
        a(href = "https://github.com/tamas-ferenci/OkspecifikusMortalitasiAdatbazis",
          target = "_blank", "leírást", .noWS = "outside"),
        ", mely igyekszik közérthetően összefoglalni a legfontosabb szempontokat."),
      p(paste0("Ugyanezen a linken elérhető részletes technikai magyarázat is a weboldal ",
               "működéséhez, valamint letölthető a teljes forráskódja mind oldalnak, mind az ",
               "adatok előkészítését végző szkriptnek, így az oldal teljesen transzparens.")),
      p("Az adatbázist összeállította és a weboldalt készítette: ",
        a(href = "https://www.medstat.hu/", target = "_blank", "Ferenci Tamás",
          .noWS = "outside"),
        ". A weboldal és a közölt adatok, nézetek nem tekinthetőek semmilyen szerv hivatalos ",
        "álláspontjának, helyességükre garancia nincs, de a szerző örömmel vesz minden ",
        "javaslatot és kritikát (akár a Github-oldalon, akár email-ben)."),
      p(paste0("Az adatok forrása az Egészségügyi Világszervezet, a Human Mortality ",
               "Database és az Eurostat. Hivatalos deklarációk: HMD. Human Mortality ",
               "Database. Max Planck Institute for Demographic Research (Germany), University ",
               "of California, Berkeley (USA), and French Institute for Demographic Studies ",
               "(France). Available at www.mortality.org. Source of MDB data is WHO. ",
               "Analyses, interpretations and conclusions are of the author, not the WHO, ",
               "which is responsible only for the provision of the original information.")),
      easyClose = TRUE,
      footer = tagList(
        actionButton(inputId = "opening", label = "Bezárás", icon = icon("info-circle"))
      )
    ))
  })
  
  observeEvent(input$opening, {
    removeModal()
  })
  
  observeEvent(input$timeMetric,
               updateRadioButtons(inputId = "timeStratification",
                                  choices = if(input$timeMetric == "adjrate")
                                    stratsel[stratsel != "AgeLabel"] else stratsel))
  
  dataInputFun <- function(multipleICD, ICDSingle, ICDMultiple,
                           multipleCountry, countrySingle, countryMultiple,
                           strat, metric, ordVar, byvarAdd,
                           yearFilter, sexFilter, ageFilter, addCountryName) {
    
    rd <- RawData
    rdAll <- RawDataAll
    
    icd <- if(multipleICD == "Single") ICDSingle else ICDMultiple
    if(is.null(icd)) return(NULL)
    
    if(!is.na(multipleCountry)) {
      country <- if((multipleICD == "MultiIndiv")||(multipleCountry == "Single"))
        countrySingle else countryMultiple
      if(is.null(country)) return(NULL)
      
      rd <- if(length(country) == 1) rd[iso3c == country] else rd[iso3c %in% country]
      rdAll <- if(length(country) == 1) rdAll[iso3c == country] else rdAll[iso3c %in% country]
    } else country <- NA
    
    if(!is.null(yearFilter)) {
      yearSel <- seq(yearFilter[1], yearFilter[2], 1)
      rd <- rd[Year %in% yearSel]
      rdAll <- rdAll[Year %in% yearSel]
    }
    if(sexFilter != "Összesen") {
      rd <- rd[Sex == sexFilter]
      rdAll <- rdAll[Sex == sexFilter]
    }
    if((ageFilter != "Összesen") && (metric != "adjrate")) {
      rd <- rd[Age == ageFilter]
      rdAll <- rdAll[Age == ageFilter]
    } 
    
    rd <- switch(
      multipleICD,
      "Single" = rd[Cause %in% ICDGroups[[icd]],
                    .(value, CauseGroup = icd, iso3c, Year, Sex, Age, Frmat)],
      "MultiSum" = rd[Cause %in% unlist(ICDGroups[icd]),
                      .(value, CauseGroup = "Összeg", iso3c, Year, Sex, Age, Frmat)],
      "MultiIndiv" = merge(rd, data.table(stack(ICDGroups[icd]))[
        , .(Cause = values, CauseGroup = ind)], by = "Cause", allow.cartesian = TRUE))
    
    rd <- rd[, .(value = sum(value)), .(iso3c, Year, Sex, Age, Frmat, CauseGroup)]
    
    rd <- merge(data.table(base::merge.data.frame(
      rdAll, data.table(CauseGroup = if(multipleICD == "MultiSum") "Összeg" else icd))),
      rd, by = c("iso3c", "Year", "Sex", "Age", "Frmat", "CauseGroup"), all.x = TRUE)
    rd[is.na(value)]$value <- 0
    
    rd <- merge(rd, PopData, by = c("iso3c", "Year", "Sex", "Age", "Frmat"))
    
    byvars <- c("iso3c", byvarAdd)
    if(multipleICD != "MultiIndiv" && !is.na(strat) && multipleCountry == "Single")
      byvars <- c(byvars, strat[strat != "None"])
    
    rd <- switch(metric,
                 "count" = rd[Aggregated == FALSE, .(value = sum(value)), byvars],
                 "cruderate" = rd[Aggregated == FALSE,
                                  .(value = sum(value)/sum(Pop)*1e5), byvars],
                 "adjrate" = merge(
                   rd[, .(value = sum(value), Pop = sum(Pop)),
                      c(byvars, "Frmat", "Age")],
                   StdPop, by = c("Frmat", "Age"))[
                     , as.list(epitools::ageadjust.direct(value, Pop, stdpop = StdPop)),
                     byvars][, c(.SD, .(value = adj.rate*1e5))])
    
    if(!is.na(ordVar)) rd <- rd[order(rd[[ordVar]])]
    
    if(addCountryName) rd <- merge(rd, data.table(iso3c = CountryCodes,
                                                  CountryName = names(CountryCodes)))
    
    return(list(rd = rd, icd = icd, country = country))
  }
  
  dataInputTime <- reactive(dataInputFun(
    input$timeMultipleICD, input$timeICDSingle, input$timeICDMultiple,
    input$timeMultipleCountry,input$timeCountrySingle, input$timeCountryMultiple,
    input$timeStratification, input$timeMetric, "Year", c("Year", "CauseGroup"),
    NULL, "Összesen", "Összesen", FALSE))
  dataInputMap <- reactive(dataInputFun(
    "Single", input$mapICDSingle, NA,
    NA, NA, NA,
    NA, input$mapMetric, NA, NULL,
    input$mapYear, input$mapSex, input$mapAge, TRUE))
  dataInputAgesex <- reactive(dataInputFun(
    input$agesexMultipleICD, input$agesexICDSingle, input$agesexICDMultiple,
    input$agesexMultipleCountry,input$agesexCountrySingle, input$agesexCountryMultiple,
    input$agesexStratification, "cruderate", "AgeNum", c("Age", "AgeNum", "AgeLabel", "CauseGroup"),
    NULL, "Összesen", "Összesen", FALSE))
  
  output$timePlot <- renderHighchart({
    p <- highchart()
    
    di <- dataInputTime()
    mortdat <- di$rd
    gc()
    if(is.null(mortdat)) return(p)
    
    if(input$timeMultipleICD %in% c("Single", "MultiSum") && input$timeMultipleCountry == "Single" && input$timeStratification == "None")
      p <- p |> hc_add_series(mortdat, type = "line", hcaes(x = Year, y = value, group = NA),
                              name = paste0(di$icd, collapse = ", "))
    if(input$timeMultipleICD %in% c("Single", "MultiSum") && input$timeMultipleCountry == "Single" && input$timeStratification == "Sex")
      p <- p |> hc_add_series(mortdat, type = "line", hcaes(x = Year, y = value, group = Sex))
    if(input$timeMultipleICD %in% c("Single", "MultiSum") && input$timeMultipleCountry == "Single" && input$timeStratification == "AgeLabel")
      p <- p |> hc_add_series(mortdat, type = "line", hcaes(x = Year, y = value, group = AgeLabel))
    if(input$timeMultipleICD %in% c("Single", "MultiSum") && input$timeMultipleCountry == "Multiple")
      p <- p |> hc_add_series(mortdat, type = "line", hcaes(x = Year, y = value, group = iso3c))
    if(input$timeMultipleICD == "MultiIndiv") p <- p |> hc_add_series(mortdat, type = "line", hcaes(x = Year, y = value, group = CauseGroup))
    
    p <- p |>
      hc_title(text = "Mortalitás időbeli alakulása") |>
      hc_subtitle(
        text = "Okspecifikus Mortalitási Adatbázis<br>Ferenci Tamás, medstat.hu",
        align = "left", verticalAlign = "bottom") |>
      # hc_subtitle(
      #   text = "Adatok forrása:",
      #   align = "right", verticalAlign = "top") |>
      hc_xAxis(tickInterval = 1) |>
      hc_yAxis(title = list(
        text = switch(input$timeMetric, "count" = "Abszolút szám [fő]",
                      "cruderate" = "Nyers ráta [fő/100 ezer fő/év]",
                      "adjrate" = "Standardizált ráta [fő/100 ezer fő/év]")),
        type = if(input$timeLogY) "logarithmic" else "linear",
        softMin = if(input$timeYFromZero) 0 else NULL) |>
      hc_tooltip(valueDecimals = ifelse(input$timeMetric == "count", 0, 1)) |>
      hc_add_theme(hc_theme(
        chart = list(backgroundColor = "white"))) |>
      hc_credits(enabled = TRUE) |>
      hc_exporting(enabled = TRUE, chartOptions = list(legend = TRUE),
                   sourceWidth = 1600/2, sourceHeight = 900/2)
    
    if("HUN" %in% di$country) p <- p |> hc_xAxis(plotLines = list(
      list(
        label = list(text = "Módszertani változás (HUN)"),
        dashStyle = "Dash",
        value = 2004.5
      )
    ))
    
    p
  })
  
  output$mapPlot <- renderHighchart({
    di <- dataInputMap()
    mortdat <- di$rd
    gc()
    if(is.null(mortdat)) return(p)
    
    # mortdat <- RawData[Year %in% seq(input$mapYear[1], input$mapYear[2], 1)]
    # mortdat <- mortdat[Cause %in% ICDGroups[[input$mapICDSingle]]]
    # if(input$mapSex != "Összesen") mortdat <- mortdat[Sex == input$mapSex]
    # if((input$mapAge != "Összesen") && (input$mapMetric != "adjrate")) mortdat <- mortdat[Age == input$mapAge]
    # mortdat <- mortdat[, .(value = sum(value)), .(iso3c, Year, Sex, Age, Frmat)]
    # mortdat <- merge(mortdat, PopData, by = c("iso3c", "Year", "Sex", "Age", "Frmat"))
    # 
    # mortdat <- switch(input$mapMetric,
    #                   "count" = mortdat[Aggregated == FALSE, .(value = sum(value)), .(iso3c)],
    #                   "cruderate" = mortdat[Aggregated == FALSE, .(value = sum(value)/sum(Pop)*1e5), .(iso3c)],
    #                   "adjrate" = merge(mortdat[, .(value = sum(value), Pop = sum(Pop)), .(iso3c, Age, Frmat)], StdPop, by = c("Age", "Frmat"))[
    #                     , as.list(epitools::ageadjust.direct(value, Pop, stdpop = StdPop)), .(iso3c)][, c(.SD, .(value = adj.rate*1e5))])
    # 
    # mortdat <- merge(mortdat, data.table(iso3c = CountryCodes, CountryName = names(CountryCodes)))
    # 
    if(input$mapType == "Map") {
      p <- hcmap(paste0("custom/", input$mapMap), data = mortdat, value = "value",
                 joinBy = c("iso-a3", "iso3c"), name = input$mapICDSingle,
                 tooltip = list(pointFormat = "{point.CountryName}: {point.value}"))
      # p <- p |> hc_colorAxis(width = "100%")
      # p <- p |> hc_colorAxis(layout = "vertical", reversed = FALSE, margin = 0) |> hc_legend(align = "right", verticalAlign = "middle")
    } else {
      p <- hchart(mortdat[order(if(input$mapBarOrder) value else iso3c)], type = "column",
                  hcaes(x = iso3c, y = value), name = input$mapICDSingle)
      p <- p |> hc_tooltip(headerFormat = "{point.point.CountryName}<br>")
    }
    
    p <- p |>
      hc_title(text = paste0("Mortalitás területi alakulása, ",
                             if(input$mapYear[1] == input$mapYear[2]) input$mapYear[1] else
                               paste0(input$mapYear, collapse = " - "),
                             if(input$mapSex != "Összesen") paste0(", ", input$mapSex),
                             if((input$mapAge != "Összesen")&(input$mapMetric != "adjrate")) paste0(", ", input$mapAge, " év"))) |>
      hc_subtitle(
        text = "Okspecifikus Mortalitási Adatbázis<br>Ferenci Tamás, medstat.hu",
        align = "left", verticalAlign = "bottom") |>
      hc_xAxis(title = list(text = "")) |>
      hc_yAxis(title = list(
        text = switch(input$mapMetric, "count" = "Abszolút szám [fő]",
                      "cruderate" = "Nyers ráta [fő/100 ezer fő/év]",
                      "adjrate" = "Standardizált ráta [fő/100 ezer fő/év]")),
        type = if(input$timeLogY) "logarithmic" else "linear",
        softMin = if(input$timeYFromZero) 0 else NULL) |>
      hc_tooltip(valueDecimals = ifelse(input$mapMetric == "count", 0, 1)) |>
      hc_add_theme(hc_theme(
        chart = list(backgroundColor = "white"))) |>
      hc_credits(enabled = TRUE) |>
      hc_exporting(enabled = TRUE, chartOptions = list(legend = TRUE),
                   sourceWidth = 1600/2, sourceHeight = 900/2)
  })
  
  output$agesexPlot <- renderHighchart({
    p <- highchart()
    
    di <- dataInputAgesex()
    mortdat <- di$rd
    gc()
    if(is.null(mortdat)) return(p)
    
    if(input$agesexMultipleICD %in% c("Single", "MultiSum") & input$agesexMultipleCountry == "Single" & input$agesexStratification == "None")
      p <- p |> hc_add_series(mortdat, type = "line", hcaes(x = AgeNum, y = value, group = NA),
                              name = paste0(di$icd, collapse = ", "))
    if(input$agesexMultipleICD %in% c("Single", "MultiSum") & input$agesexMultipleCountry == "Single" & input$agesexStratification == "Sex")
      p <- p |> hc_add_series(mortdat, type = "line", hcaes(x = AgeNum, y = value, group = Sex))
    if(input$agesexMultipleICD %in% c("Single", "MultiSum") & input$agesexMultipleCountry == "Single" & input$agesexStratification == "Year")
      p <- p |> hc_add_series(mortdat, type = "line", hcaes(x = AgeNum, y = value, group = Year))
    if(input$agesexMultipleICD %in% c("Single", "MultiSum") & input$agesexMultipleCountry == "Multiple")
      p <- p |> hc_add_series(mortdat, type = "line", hcaes(x = AgeNum, y = value, group = iso3c))
    if(input$agesexMultipleICD == "MultiIndiv") p <- p |> hc_add_series(mortdat, type = "line", hcaes(x = AgeNum, y = value, group = CauseGroup))
    
    p <- p |>
      hc_title(text = "Mortalitás életkor- és nem-függése") |>
      hc_subtitle(
        text = "Okspecifikus Mortalitási Adatbázis<br>Ferenci Tamás, medstat.hu",
        align = "left", verticalAlign = "bottom") |>
      # hc_subtitle(
      #   text = "Adatok forrása:",
      #   align = "right", verticalAlign = "top") |>
      hc_xAxis(title = list(text = "Életkor [év]")) |>
      hc_yAxis(title = list(text = "Nyers ráta [fő/100 ezer fő/év]"),
               type = if(input$agesexLogY) "logarithmic" else "linear",
               softMin = if(input$agesexYFromZero) 0 else NULL) |>
      hc_tooltip(valueDecimals = 1, headerFormat = "{point.point.AgeLabel} év<br>") |>
      hc_add_theme(hc_theme(chart = list(backgroundColor = "white"))) |>
      hc_credits(enabled = TRUE) |>
      hc_exporting(enabled = TRUE, chartOptions = list(legend = TRUE),
                   sourceWidth = 1600/2, sourceHeight = 900/2)
    
    p
  })
  
  observeEvent(input$hunworldEU27,
               shinyWidgets::updatePickerInput(inputId = "hunworldCountryMultiple",
                                               selected = EUCountries$EU27))
  observeEvent(input$hunworldEU15,
               shinyWidgets::updatePickerInput(inputId = "hunworldCountryMultiple",
                                               selected = EUCountries$EU15))
  observeEvent(input$hunworldEU11,
               shinyWidgets::updatePickerInput(inputId = "hunworldCountryMultiple",
                                               selected = EUCountries$EU11))
  observeEvent(input$hunworldV4,
               shinyWidgets::updatePickerInput(inputId = "hunworldCountryMultiple",
                                               selected = EUCountries$V4))
  
  datainputHunworld <- reactive({
    mortdat <- RawData[iso3c %in% c("HUN", input$hunworldCountryMultiple)]
    mortdat <- mortdat[Year %in% seq(input$hunworldYear[1], input$hunworldYear[2], 1)]
    mortdat <- merge(mortdat, data.table(stack(ICDGroups[ICDmulti]))[, .(Cause = values, CauseGroup = ind)],
                     by = "Cause", allow.cartesian = TRUE)
    mortdat <- mortdat[, .(value = sum(value)), .(iso3c, Year, Sex, Age, Frmat, CauseGroup)]
    mortdat <- merge(mortdat, PopData, by = c("iso3c", "Year", "Sex", "Age", "Frmat"))
    mortdat <- mortdat[, .(value = sum(value), Pop = sum(Pop)), .(HUN = ifelse(iso3c=="HUN", "HUN", "Comparator"), Age, Frmat, CauseGroup)]
    mortdat <- merge(mortdat, StdPop, by = c("Age", "Frmat"))[
      , as.list(epitools::ageadjust.direct(value, Pop, stdpop = StdPop)), .(HUN, CauseGroup)][, c(.SD, .(value = adj.rate*1e5))]
    mortdat <- dcast(mortdat[, .(HUN, CauseGroup, value)], CauseGroup ~ HUN, value.var = "value")
  })
  
  output$hunworldPlot <- renderHighchart({
    mortdat <- datainputHunworld()
    gc()
    
    p <- hchart(if("Comparator" %in% names(mortdat)) mortdat else
      data.table(HUN = numeric(), Comparator = numeric(), CauseGroup = character), "point",
      hcaes(x = HUN, y = Comparator, group = CauseGroup))
    
    p <- p |>
      hc_title(text = paste("Magyarország összehasonlítása más országokkal<br>",
                            "Összehasonlítási alap a következő országok átlaga: ",
                            paste0(input$hunworldCountryMultiple, collapse = ", "))) |>
      hc_subtitle(
        text = "Okspecifikus Mortalitási Adatbázis<br>Ferenci Tamás, medstat.hu",
        align = "left", verticalAlign = "bottom") |>
      hc_annotations(list(draggable = FALSE,
                          shapes = list(type = "path", strokeWidth = 2,
                                        points = list(
                                          list(x = 1e-6, y = 1e-6, xAxis = 0, yAxis = 0),
                                          list(x = 1e6, y = 1e6, xAxis = 0, yAxis = 0))))) |>
      hc_xAxis(title = list(text = "Magyarország standardizált mortalitási ráták [/100 ezer fő/év]"),
               type = if(input$hunworldLog) "logarithmic" else "linear",
               min = if(input$hunworldXRangeSet) input$hunworldXRange[1],
               max = if(input$hunworldXRangeSet) input$hunworldXRange[2]) |>
      hc_yAxis(title = list(text = "A többi ország standardizált mortalitási rátája [/100 ezer fő/év]"),
               type = if(input$hunworldLog) "logarithmic" else "linear") |>
      hc_legend(enabled = FALSE) |>
      hc_tooltip(pointFormat = "Magyarország: {point.x:.1f}<br>Összehasonlítási országok: {point.y:.1f}") |>
      hc_add_theme(hc_theme(chart = list(backgroundColor = "white"))) |>
      hc_credits(enabled = TRUE) |>
      hc_exporting(enabled = TRUE, chartOptions = list(legend = TRUE),
                   sourceWidth = 1600/2, sourceHeight = 900/2)
    
    p
  })
  
  output$dimredvizPlot <- renderHighchart({
    hchart(dimredvizData[Method == input$dimredvizMethod], "point",
           hcaes(x = V1, y = V2, group = iso3c, color = iso3c,
                 shape = ifelse(Sex == "Férfi", "square", "circle"))) |>
      hc_chart(events = list(load = JS("function() {
        var chart = this,
          seriess = chart.series;
          
          seriess.forEach(function(series, index) {
          var points = series.points;
            points.forEach(function(point, index) {
              point.update({
                marker: {
                  symbol: point.shape
                }
              });
            });
          });
      }")
      )) |>
      hc_title(text = paste0("Mortalitási profilok vizualizációja dimenziócsökkentéssel",
                             " (alkalmazott módszer: ", input$dimredvizMethod, ")")) |>
      hc_subtitle(
        text = paste0("Férfi: ◼, Nő: ⚫︎<br>Okspecifikus Mortalitási Adatbázis<br>",
                      "Ferenci Tamás, medstat.hu"),
        align = "left", verticalAlign = "bottom") |>
      hc_add_theme(hc_theme(chart = list(backgroundColor = "white"))) |>
      hc_credits(enabled = TRUE) |>
      hc_exporting(enabled = TRUE, chartOptions = list(legend = TRUE),
                   sourceWidth = 1600/2, sourceHeight = 900/2) |>
      hc_xAxis(title = list(text = ""), gridLineWidth = 1, labels = list(enabled = FALSE),
               tickLength = 0, startOnTick = TRUE, endOnTick = TRUE) |>
      hc_yAxis(title = list(text = ""), labels = list(enabled = FALSE), tickLength = 0) |>
      hc_plotOptions(scatter = list(marker = list(radius = 3))) |>
      hc_tooltip(pointFormat = "",
                 headerFormat =
                   "{point.point.iso3c}, {point.point.Sex}, {point.point.Year}<br>")
  })
}

shinyApp(ui = ui, server = server)