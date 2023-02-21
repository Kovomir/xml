<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:z="urn:kovj19:zajezdy"
    exclude-result-prefixes="xs z" version="2.0">

    <xsl:output method="html" version="5" name="html5"/>

    <xsl:template match="/">
        <html lang="cs">
            <head>
                <title>Zájezdy</title>
                <link rel="stylesheet" type="text/css" href="zajezdy_styly.css" media="screen,print"
                />
            </head>
            <body>
                <header>
                    <h1>Zájezdy</h1>
                </header>
                <section>
                    <xsl:apply-templates select="." mode="menu"/>
                    <xsl:apply-templates select="." mode="pages"/>
                </section>
                <footer>
                    <xsl:call-template name="copyright"/>
                </footer>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="z:zajezdy" mode="menu">
        <xsl:for-each-group select="z:zajezd" group-by="z:zeme">
            <h2>
                <xsl:value-of select="current-grouping-key()"/>
            </h2>
            <div class="menu">
                <xsl:for-each select="current-group()">
                    <xsl:sort select="z:nazev"/>
                    <xsl:apply-templates select="." mode="menu"/>
                </xsl:for-each>
            </div>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template match="z:zajezd" mode="menu">
        <a href="{generate-id()}.html">
            <p>
                <xsl:value-of select="z:nazev"/>
            </p>
            <img src="{z:fotky/*[1]/z:src}" alt="{z:fotky/*[1]/z:alt}"/>
        </a>
    </xsl:template>

    <xsl:template match="z:zajezdy" mode="pages">
        <xsl:apply-templates select="z:zajezd" mode="pages"/>
    </xsl:template>

    <xsl:template match="z:zajezd" mode="pages">
        <xsl:result-document href="{generate-id()}.html" format="html5">
            <html lang="cs">
                <head>
                    <title>
                        <xsl:value-of select="z:nazev"/>
                    </title>
                    <link rel="stylesheet" type="text/css" href="zajezdy_styly.css"
                        media="screen,print"/>
                </head>
                <body>
                    <header>
                        <h1>
                            <xsl:value-of select="z:nazev"/> (<xsl:value-of select="z:zeme"/>) </h1>
                    </header>
                    <section>
                        <a href="index.html">Zpět na seznam zájezdů</a>
                        <h2> Turnusy: </h2>
                        <ol>
                            <xsl:apply-templates select="z:turnus">
                                <xsl:sort select="z:datumOdjezdu" order="ascending"/>
                            </xsl:apply-templates>
                        </ol>
                    </section>
                    <footer>
                        <xsl:call-template name="copyright"/>
                    </footer>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="z:turnus">
        <li class="turnus">
            <ul>
                <li>Instruktoři: <xsl:value-of select="z:instruktori"/></li>
                <li>Datum odjezdu: <xsl:value-of
                        select="format-date(z:datumOdjezdu, '[D01].[M01].[Y0001]')"/></li>
                <li>Datum příjezdu: <xsl:value-of
                        select="format-date(z:datumPrijezdu, '[D01].[M01].[Y0001]')"/></li>
                <li>Ubytování: <xsl:value-of select="z:ubytovani/@typ"/></li>
                <xsl:if test="z:ubytovani/z:adresa">
                    <li class="no-bullets">
                        <ul>
                            <li>Adresa: <xsl:value-of select="z:ubytovani/z:adresa/z:ulice"/>,
                                <xsl:value-of select="z:ubytovani/z:adresa/z:mesto"/>, <xsl:value-of
                                    select="z:ubytovani/z:adresa/z:psc"/></li>
                        </ul>
                    </li>
                </xsl:if>
                <li>Strava: <xsl:value-of select="z:strava"/></li>
                <li>Doprava: <xsl:value-of select="z:doprava"/></li>
                <li>Počet míst: <xsl:value-of select="z:pocetMist"/></li>
                <li>Cena: <xsl:value-of select="z:cena"/> Kč</li>
                <li>Povinná výbava: <xsl:value-of select="z:povinnaVybava"/></li>
                <li>Fyzická náročnost: <xsl:value-of select="z:fyzickaNarocnost"/></li>
            </ul>
            <xsl:apply-templates select="z:prihlaseni"/>
        </li>
    </xsl:template>

    <xsl:template match="z:prihlaseni">
        <h3>Přihlášení:</h3>
        <xsl:if test="count(z:klient) = 0">
            <xsl:text>
                Na turnus zatím není nikdo přihlášen.
            </xsl:text>
        </xsl:if>
        <xsl:for-each select="z:klient">
            <xsl:sort select="z:prijmeni"/>
            <xsl:apply-templates select="."/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="z:klient">
        <div class="klient">
            <ul>
                <li>
                    <strong>Identifikace:</strong>
                </li>
                <li class="no-bullets">
                    <ul>
                        <li>Jméno a příjmení: <xsl:value-of select="z:jmeno"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="z:prijmeni"/></li>
                        <li>Pohlaví: <xsl:value-of select="z:pohlavi"/></li>
                        <li>Datum narození: <xsl:value-of
                            select="format-date(z:datumNarozeni, '[D01].[M01].[Y0001]')"/></li>
                        <li>Státní příslušnost: <xsl:value-of select="z:statniPrislusnost"/></li>
                    </ul>
                </li>
                <li>
                    <strong>Kontaktní informace:</strong>
                </li>
                <li class="no-bullets">
                    <ul>
                        <li>Email: <xsl:value-of select="z:email"/></li>
                        <li>Telefonní číslo: <xsl:value-of select="z:telefon"/></li>
                        <li>Trvalé bydliště: <xsl:value-of select="z:trvaleBydliste/z:ulice"/>,
                            <xsl:value-of select="z:trvaleBydliste/z:mesto"/>, <xsl:value-of
                                select="z:trvaleBydliste/z:psc"/></li>
                    </ul>
                </li>
                <li>
                    <strong>Zaplaceno: </strong>
                    <xsl:value-of select="z:zaplaceno"/>
                </li>
            </ul>
        </div>
    </xsl:template>

    <xsl:template name="copyright">
        <p>&#169; Jan Kovář | ZS 2022/2023</p>
    </xsl:template>
</xsl:stylesheet>
