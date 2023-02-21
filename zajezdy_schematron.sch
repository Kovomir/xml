<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
    <sch:ns uri="urn:kovj19:zajezdy" prefix="z"></sch:ns>
    
    <sch:pattern>
        <sch:title>Počet míst</sch:title>
        <sch:rule context="z:zajezd/z:turnus">
            <sch:report test="count(z:prihlaseni/z:klient) &gt; z:pocetMist">Počet přihlášených klientů na turnusu nesmí přesáhnout počet míst.</sch:report>            
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:title>Datum odjezdu a příjezdu</sch:title>
        <sch:rule context="z:zajezd/z:turnus">
            <sch:assert test="z:datumOdjezdu &lt;= z:datumPrijezdu">Datum odjezdu musí být menší, nebo stejné jako datum příjezdu.</sch:assert>           
        </sch:rule>
    </sch:pattern>
    
    <!-- Z bezpečnostních důvodů je ve firemní politice pravidlo,
         že na jednoho instruktora nesmí být na turnusu více než 10 klientů. -->
    <sch:pattern>
        <sch:title>Počet klientů na instruktora</sch:title>
        <sch:rule context="z:zajezd/z:turnus">
            <sch:report test="z:pocetMist &gt; (count(z:instruktori/z:instruktor) * 10)">Počet míst na turnusu nesmí být větší než počet instruktorů * 10.</sch:report>           
        </sch:rule>
    </sch:pattern>
    
</sch:schema>