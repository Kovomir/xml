<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:z="urn:kovj19:zajezdy" exclude-result-prefixes="xs z" version="2.0">

    <xsl:output method="xml" encoding="utf-8"/>

    <xsl:template match="/">
        <fo:root>
            <fo:layout-master-set>
                <!-- Rozměry stránky a její okraje -->
                <fo:simple-page-master master-name="a4" page-height="297mm" page-width="210mm"
                    margin="1in">
                    <fo:region-body margin-bottom="15mm" margin-top="15mm"/>
                    <fo:region-before extent="10mm"/>
                    <fo:region-after extent="10mm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>

            <!-- Definice obsahu stránky -->
            <fo:page-sequence master-reference="a4" font-family="Calibri" font-size="11pt"
                line-height="1.15">
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block>
                        <xsl:text>Strana </xsl:text>
                        <fo:page-number/>
                    </fo:block>
                </fo:static-content>
                <fo:static-content flow-name="xsl-region-before">
                    <fo:block font-size="8pt">
                        <xsl:text>Jan Kovář | ZS 2022/2023</xsl:text>
                    </fo:block>
                </fo:static-content>
                <!-- Samotný text dokumentu -->
                <fo:flow flow-name="xsl-region-body">
                    <fo:block>
                        <xsl:apply-templates select="z:zajezdy"/>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>

    <xsl:template match="z:zajezdy">
        <fo:block font-size="32pt">Zájezdy</fo:block>

        <fo:block margin-top="10mm">

            <fo:block font-size="23pt" margin-bottom="5mm"> Obsah </fo:block>
            <xsl:for-each select="z:zajezd">
                <fo:block text-align="justify" text-align-last="justify" margin-bottom="3mm">
                    <fo:basic-link internal-destination="{generate-id()}">
                        <xsl:value-of select="z:nazev"/>
                    </fo:basic-link>
                    <fo:leader leader-pattern="dots" padding-right="2mm" padding-left="1mm"/>
                    <fo:page-number-citation ref-id="{generate-id()}"/>
                </fo:block>
            </xsl:for-each>
        </fo:block>

        <fo:block text-align="center" margin="25mm">
            <fo:external-graphic src="url(resources/adventure.jpg)" display-align="center"
                width="800px" height="500px" content-width="800px" content-height="500px"/>
        </fo:block>

        <xsl:apply-templates select="z:zajezd"/>
    </xsl:template>

    <xsl:template match="z:zajezd">
        <fo:block id="{generate-id()}" font-size="28pt" page-break-before="always"
            margin-bottom="8mm">
            <xsl:apply-templates select="z:nazev"/>
        </fo:block>

        <fo:block text-align="center">
            <fo:external-graphic src="url({z:fotky/*[1]/z:src})" display-align="center"
                width="640px" height="400px" content-width="640px" content-height="400px"/>
            <fo:block>
                <xsl:value-of select="z:fotky/*[1]/z:alt"/>
            </fo:block>
            <fo:block> Země: <xsl:value-of select="z:zeme"/>
            </fo:block>
        </fo:block>

        <xsl:apply-templates select="z:turnus"/>
    </xsl:template>

    <xsl:template match="z:zajezdy/z:zajezd/z:turnus">
        <fo:block font-size="20pt">Turnus:</fo:block>
        <fo:table border="solid black 2px" keep-together.within-page="always" margin-bottom="3mm"
            margin-top="3mm">
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px">
                        <fo:block>Instruktoři:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of select="z:instruktori"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px">
                        <fo:block>Datum odjezdu:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of
                                select="format-date(z:datumOdjezdu, '[D01].[M01].[Y0001]')"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px">
                        <fo:block>Datum příjezdu:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of
                                select="format-date(z:datumPrijezdu, '[D01].[M01].[Y0001]')"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px">
                        <fo:block>Ubytování:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of select="z:ubytovani/@typ"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <xsl:if test="z:ubytovani/z:adresa">
                    <fo:table-row>
                        <fo:table-cell width="45mm" border-style="solid" padding="2px">
                            <fo:block>Adresa ubytování:</fo:block>
                        </fo:table-cell>
                        <fo:table-cell border-style="solid" padding="2px">
                            <fo:block>
                                <xsl:value-of select="z:ubytovani/z:adresa/z:ulice"/>, <xsl:value-of
                                    select="z:ubytovani/z:adresa/z:mesto"/>, <xsl:value-of
                                    select="z:ubytovani/z:adresa/z:psc"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:if>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px">
                        <fo:block>Strava:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of select="z:strava"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px">
                        <fo:block>Doprava:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of select="z:doprava"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px">
                        <fo:block>Počet míst:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of select="z:pocetMist"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px">
                        <fo:block>Cena:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of select="z:cena"/> Kč </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px">
                        <fo:block>Povinná výbava:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of select="z:povinnaVybava"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px">
                        <fo:block>Fyzická náročnost:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of select="z:fyzickaNarocnost"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>

        <xsl:apply-templates select="z:prihlaseni"/>
    </xsl:template>

    <xsl:template match="z:prihlaseni">
        <fo:block keep-together.within-page="always">
            <fo:block font-size="15pt" margin-bottom="3mm">Přihlášení: </fo:block>

            <xsl:if test="count(z:klient) = 0">
                <fo:block> Na turnus není nikdo přihlášen.</fo:block>
            </xsl:if>

            <xsl:apply-templates select="z:klient"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="z:zajezdy/z:zajezd/z:turnus/z:prihlaseni/z:klient">
        <fo:table border="solid black 2px" keep-together.within-page="always" margin-bottom="3mm"
            margin-top="3mm">
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px"
                        text-align="center">
                        <fo:block font-weight="bold">Identifikace:</fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px">
                        <fo:block>Jméno a příjmení:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of select="z:jmeno"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="z:prijmeni"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px">
                        <fo:block>Pohlaví:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of select="z:pohlavi"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px">
                        <fo:block>Datum narození:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of
                                select="format-date(z:datumNarozeni, '[D01].[M01].[Y0001]')"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px">
                        <fo:block>Státní příslušnost:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of select="z:statniPrislusnost"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px"
                        text-align="center">
                        <fo:block font-weight="bold">Kontaktní informace:</fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px">
                        <fo:block>Email:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of select="z:email"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px">
                        <fo:block>Telefonní číslo:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of select="z:telefon"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px">
                        <fo:block>Trvalé bydliště:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of select="z:trvaleBydliste/z:ulice"/>, <xsl:value-of
                                select="z:trvaleBydliste/z:mesto"/>, <xsl:value-of
                                select="z:trvaleBydliste/z:psc"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell width="45mm" border-style="solid" padding="2px"
                        font-weight="bold" text-align="center">
                        <fo:block>Zaplaceno:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-style="solid" padding="2px">
                        <fo:block>
                            <xsl:value-of select="z:zaplaceno"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>

</xsl:stylesheet>
