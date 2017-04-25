<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math xd tei"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Apr 25, 2017</xd:p>
            <xd:p><xd:b>Author:</xd:b> Johannes Kepper</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="html" indent="yes" doctype-public="html"/>
    <xsl:template match="/">
        <html lang="en">
            <head>
                <meta charset="utf-8" />
                <title>MEI Basic Documentation</title>
            </head>
            <body>
                <h1>
                    <xsl:apply-templates select="(.//tei:title)[1]//text()"/>
                </h1>
                
            </body>
        </html>
    </xsl:template>
    
    
    
    <xsl:template match="node() | @*" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>