<?xml version="1.0" encoding="utf-8"?>
<xsl:transform version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:doc="http://docbook.org/ns/docbook"
    xmlns:xl="http://www.w3.org/1999/xlink"
    xmlns:md2doc="http://www.markdown2docbook.com/ns/md2doc"
    xmlns:d="data:,dpc"
    exclude-result-prefixes="xs xl doc d md2doc" xpath-default-namespace="">
    
    <!--
        MAIN stylesheet

        Markdown Parser in XSLT2 Copyright 2014 Martin Šmíd
        This code is under MIT licence, see more at https://github.com/MSmid/markdown2docbook
    -->

    <xsl:import href="md2doc-functions.xsl"/>
    

    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" indent="yes" />
    <xsl:output name="docbook" encoding="UTF-8" method="xml" indent="yes" />
    <xsl:output name="html5" encoding="UTF-8" method="html" indent="yes"
        doctype-system="about:legacy-compat"/>
    <xsl:output name="xhtml" encoding="UTF-8" method="xhtml" indent="yes"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
        doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
        omit-xml-declaration="yes"/>

    <!--Specifies if all document should be wrapped in element (like Book or perhaps Chapter)-->
    <xsl:param name="root-element" as="xs:string" select="'book'"/>
    <!--Specifies which docbook element should be match with h1 headlines-->
    <xsl:param name="headline-element" as="xs:string" select="'chapter'"/>

    <xsl:param name="input" as="xs:string" select="''"/>
    <xsl:param name="encoding " as="xs:string" select="'UTF-8'"/>
    <xsl:param name="savepath" as="xs:string" select="''"/>

    <!--
    ! Main template, which parses input source file and outputs DocBook XML file. This can be used as initial
    ! template, when we need to call standalone XSLT for transforming some Markdown file. Root and headline parameters
    !
    ! @param $input location of the source file
    ! @param $encoding of the source file
    ! @param $root-element specifies if root element is needed
    ! @param $headline-element specifies if h1 elements should be wrapped in passed element
    ! @param $savepath location and name where output should be saved (eg ../output.xml)
    -->
    <xsl:template name="main">
        <xsl:param name="input" as="xs:string" select="$input"/>
        <xsl:param name="encoding" as="xs:string" select="$encoding"/>
        <xsl:param name="root-element" as="xs:string" select="$root-element"/>
        <xsl:param name="headline-element" as="xs:string" select="$headline-element"/>
        <xsl:param name="savepath" as="xs:string" select="$savepath"/>

        <xsl:result-document href="{$savepath}" format="docbook">
            <xsl:processing-instruction name="xml-model">href="http://docbook.org/xml/5.0/rng/docbook.rng" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
            <xsl:processing-instruction name="xml-model">href="http://docbook.org/xml/5.0/rng/docbook.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron</xsl:processing-instruction>

            <xsl:sequence select="md2doc:convert(md2doc:read-file($input, $encoding), $root-element,$headline-element)"/>

        </xsl:result-document>
    </xsl:template>

    <!--
    ! Template version of get-html() function, that can be used from XSLT instead of XPath.
    !
    ! @param $input string to be parsed into HTML
    ! @return HTML tree
    -->
    <xsl:template name="get-html">
        <xsl:param name="input" as="xs:string" select="$input"/>

        <xsl:sequence select="md2doc:get-html($input)"/>
        
    </xsl:template>
    
    <!--
    ! Template version of convert() function, that can be used from XSLT instead of XPath.
    !
    ! @param $input string to be parsed into HTML
    ! @param $root-element specifies if root element is needed
    ! @param $headline-element specifies if h1 elements should be wrapped in passed element
    ! @return HTML tree
    -->
    <xsl:template name="convert">
        <xsl:param name="input" as="xs:string" select="$input"/>
        <xsl:param name="root-element" as="xs:string" select="$root-element"/>
        <xsl:param name="headline-element" as="xs:string" select="$headline-element"/>
        
        <!--<xsl:sequence select="md2doc:convert($input,$root-element,$headline-element)"/>-->
        <xsl:sequence select="md2doc:convert($input,$root-element,$headline-element)"/>
        
    </xsl:template>
    
    <!--Testing template, will be removed in final version-->
    <xsl:template name="test">
        <xsl:param name="encoding" as="xs:string" select="'utf-8'"/>
        <xsl:param name="input" as="xs:string" select="'../test/in/stackoverflow.md'"/>

        <xsl:result-document href="../test/out/output.xml" format="xhtml" exclude-result-prefixes="doc">
            <!--<xsl:sequence select="md2doc:print-disclaimer()"/>-->
            <html>
                <head>
                    <title></title>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                </head>
                <body>
                    <xsl:choose>
                        <xsl:when test="$encoding eq ''">
                            <xsl:sequence select="md2doc:get-html($input)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="input"
                                select="md2doc:read-file($input, $encoding)"/>
                            <xsl:sequence select="md2doc:get-html($input)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </body>
            </html>
        </xsl:result-document>
        <xsl:result-document href="../test/out/output3.xml" format="docbook">
            <xsl:processing-instruction name="xml-model">href="http://docbook.org/xml/5.0/rng/docbook.rng" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
            <xsl:processing-instruction name="xml-model">href="http://docbook.org/xml/5.0/rng/docbook.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron</xsl:processing-instruction>
            <xsl:choose>
                <xsl:when test="$encoding eq ''">
                    <xsl:sequence select="md2doc:convert($input, $root-element, $headline-element)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="md2doc:convert(md2doc:read-file($input, $encoding), 'book', 'chapter')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:result-document>
        
        <xsl:result-document href="../test/out/output2.xml" format="xhtml">
            <html>
                <head>
                    <title></title>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                </head>
                <body>
                    <xsl:choose>
                        <xsl:when test="$encoding eq ''">
                            <xsl:sequence select="d:htmlparse($input)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="input"
                                select="md2doc:read-file($input, $encoding)"/>
                            <xsl:sequence select="d:htmlparse($input,'',true())"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </body>
            </html>
        </xsl:result-document>

    </xsl:template>


</xsl:transform>
