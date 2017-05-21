<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:egx="http://www.tei-c.org/ns/Examples"
    xmlns:mei="http://www.music-encoding.org/ns/mei"
    xmlns:uuid="java:java.util.UUID"
    exclude-result-prefixes="xs math xd tei egx mei uuid"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Apr 25, 2017</xd:p>
            <xd:p><xd:b>Author:</xd:b> Johannes Kepper</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="html" indent="yes" doctype-public="html"/>
    
    <xsl:variable name="chapters" select=".//tei:front//tei:div[@type = 'chapter']" as="node()*"/>
    <xsl:variable name="rawDoc" select="/tei:TEI" as="node()"/>
    
    <xsl:variable name="samples" select="distinct-values(.//tei:eg/tei:notatedMusic/tei:ptr/@target)" as="xs:string*"/>
    
    <xsl:template match="/">
        
        <xsl:for-each select="$samples">
            
            <xsl:variable name="sampleUri" select="." as="xs:string"/>
            <xsl:variable name="sampleFile" select="doc('../samples/' || $sampleUri)" as="node()?"/>
            
            
            <xsl:result-document href="./../dist/samples/{$sampleUri}" method="xml" indent="yes">
                <xsl:apply-templates select="$sampleFile" mode="removeNamespace"/> 
            </xsl:result-document>
        </xsl:for-each>
        
        <xsl:for-each select="$chapters">
            <xsl:variable name="chapterName" select="@xml:id" as="xs:string"/>
            <xsl:variable name="chapterPos" select="position()" as="xs:integer"/>
            <xsl:result-document href="./../dist/{$chapterName}.html">
                <html lang="en">
                    <head>
                        <meta charset="utf-8" />
                        <title>MEI Basic Documentation</title>
                        <link rel="stylesheet" href="resources/css/spectre/spectre.min.css" />
                        <link rel="stylesheet" href="resources/css/spectre/spectre-icons.min.css" />
                        <link rel="stylesheet" href="https://picturepan2.github.io/spectre/css/docs.css" />
                        <link rel="stylesheet" href="resources/css/mei-basic-doc.css" />
                        <script src="resources/js/ace/ace.js" type="text/javascript" charset="utf-8"></script>
                        <!--<script src="resources/js/markuppretty.js" type="text/javascript" charset="utf-8"></script>
                        --><script src="resources/js/jquery-3.2.1.min.js" type="text/javascript" charset="utf-8"></script>
                        <script src="resources/js/verovio-toolkit.js" type="text/javascript" charset="utf-8"></script>
                        <script>
                            
                            /*set up Verovio*/
                            var vrvToolkit = new verovio.toolkit();                            
                            vrvToolkit.setOptions({
                            pageHeight: 210,
                            pageWidth: 420,
                            ignoreLayout: 1,
                            border: 0,
                            scale: 35
                            });
                            
                            /*function called to show the right code*/
                            var showCode = function(which, id) {
                            
                                if(which === 'excerpt') {
                                    document.getElementById(id + '_excerpt_link').classList.add('active');
                                    document.getElementById(id + '_full_link').classList.remove('active');
                                    document.getElementById(id + '_excerpt_container').classList.remove('hide');
                                    document.getElementById(id + '_full_container').classList.add('hide');
                                } else {
                                    document.getElementById(id + '_excerpt_link').classList.remove('active');
                                    document.getElementById(id + '_full_link').classList.add('active');
                                    document.getElementById(id + '_excerpt_container').classList.add('hide');
                                    document.getElementById(id + '_full_container').classList.remove('hide');
                                }
                            };
                            
                            var loadMEI = function(id,uri) {
                            
                                $.get('./samples/' + uri, function( fullMei ) {
                                    var fullEditor = ace.edit(document.getElementById(id + '_full'));
                                    fullEditor.setTheme("ace/theme/textmate");
                                    fullEditor.getSession().setMode("ace/mode/xml");
                                    fullEditor.setReadOnly(true);
                                    fullEditor.session.setValue(fullMei);
                                    
                                    var svg = vrvToolkit.renderData(fullMei + '\n ', {});
                                    
                                    document.getElementById(id + '_verovio').innerHTML = svg;
                                
                                }, 'text');
                            };
                            
                        </script>
                    </head>
                    <body>
                        <section class="section section-header bg-gray">
                            <section class="grid-header container grid-960">
                                <nav class="navbar">
                                    <section class="navbar-section">
                                        <a href="#sidebar" class="btn btn-lg btn-link btn-action show-sm"><i class="icon icon-menu"></i></a>
                                        <a href="index.html" class="navbar-brand mr-10">MEI Basic Documentation</a>
                                        <a href="index.html" class="btn btn-link">Docs</a>
                                    </section>
                                    <section class="navbar-section">
                                        <a href="https://github.com/music-encoding/mei-basic-doc" target="_blank" class="btn btn-primary">GitHub</a>
                                    </section>
                                </nav>
                            </section>
                        </section>
                        
                        <section class="container grid-960">
                            <section class="columns">
                                <div id="sidebar" class="docs-sidebar column col-3 col-sm-12">
                                    <ul class="docs-nav nav">
                                        <xsl:for-each select="$rawDoc//tei:front/tei:div">
                                            <li class="nav-item">
                                                <xsl:variable name="link" select="if(@xml:id) then(@xml:id) else(./tei:div[1]/@xml:id)" as="xs:string"/>
                                                <a href="{$link}.html">
                                                    <xsl:choose>
                                                        <xsl:when test="$chapterName = (@xml:id, descendant::tei:div/@xml:id)">
                                                            <strong>
                                                                <xsl:value-of select="./tei:head/text()"/>
                                                            </strong>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="./tei:head/text()"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </a>
                                                <xsl:if test="./tei:div">
                                                    <ul class="nav">
                                                        <xsl:for-each select="./tei:div">
                                                            <li class="nav-item">
                                                                <xsl:variable name="link" select="if(@xml:id) then(@xml:id) else(./tei:div[1]/@xml:id)" as="xs:string"/>
                                                                <a href="{$link}.html">
                                                                    <xsl:choose>
                                                                        <xsl:when test="$chapterName = (@xml:id, descendant::tei:div/@xml:id)">
                                                                            <strong><em>
                                                                                <xsl:value-of select="./tei:head/text()"/>
                                                                            </em></strong>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:value-of select="./tei:head/text()"/>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </a>
                                                            </li>
                                                        </xsl:for-each>
                                                    </ul>
                                                </xsl:if>
                                            </li>
                                        </xsl:for-each>
                                        
                                    </ul>
                                </div>
                                <div class="docs-content column col-9 col-sm-12">
                                    
                                    <!-- content -->
                                    <section id="grid" class="container">
                                        <header class="text-center">
                                            <h3><xsl:value-of select="./tei:head/text()"/></h3>
                                        </header>
                                        
                                        <xsl:apply-templates select="node() except (./tei:head)"/>
                                        <!--
                                        <section class="notes">
                                            <p><strong>Layout</strong> includes flexbox based responsive grid system with 12 columns. </p>
                                        </section>
                                        <section class="notes">
                                            <p>Add the <code>columns</code> class to a container with the <code>container</code> class. And add any element you want with the <code>column</code> class inside the container. These columns will take up the space equally. You can specific the width of each column by adding class <code>col-[1-12]</code>.</p>
                                            <p>And you can add the <code>col-gapless</code> class to have gapless columns.</p>
                                        </section>-->
                                    </section>
                                    
                                    <!-- page navigation -->
                                    <section class="container">
                                        <div class="divider"></div>
                                        <ul class="pagination">
                                            
                                            <xsl:variable name="prevChapter" as="node()?">
                                                <xsl:choose>
                                                    <xsl:when test="$chapterPos = 1"/>
                                                    <xsl:otherwise>
                                                        <xsl:sequence select="$chapters[$chapterPos - 1]"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <xsl:if test="$prevChapter">
                                                <li class="page-item page-prev">
                                                    <a href="{$prevChapter/@xml:id}.html">
                                                        <p class="page-item-subtitle">Previous</p>
                                                        <h4 class="page-item-title">
                                                            <xsl:value-of select="$prevChapter/tei:head/text()"/>
                                                        </h4>
                                                    </a>
                                                </li>
                                            </xsl:if>
                                            
                                            <xsl:variable name="nextChapter" as="node()?">
                                                <xsl:choose>
                                                    <xsl:when test="$chapterPos = count($chapters)"/>
                                                    <xsl:otherwise>
                                                        <xsl:sequence select="$chapters[$chapterPos + 1]"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <xsl:if test="$nextChapter">
                                                <li class="page-item page-next">
                                                    <a href="{$nextChapter/@xml:id}.html">
                                                        <p class="page-item-subtitle">Next</p>
                                                        <h4 class="page-item-title">
                                                            <xsl:value-of select="$nextChapter/tei:head/text()"/>
                                                        </h4>
                                                    </a>
                                                </li>
                                            </xsl:if>
                                        </ul>
                                    </section>
                                </div>
                            </section>
                        </section>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="tei:div">
        <div><xsl:apply-templates select="node() | @*"/></div>
    </xsl:template>
    
    <xsl:template match="tei:head">
        <xsl:variable name="level" select="string(count(ancestor::tei:div) + 1)" as="xs:string"/>
        <xsl:element name="h{$level}">
            <xsl:apply-templates select="node() | @*"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p><xsl:apply-templates select="node() | @*"/></p>
    </xsl:template>
    
    <xsl:template match="tei:att">
        <span class="att"><xsl:apply-templates select="node() | @*"/></span>
    </xsl:template>
    
    <xsl:template match="tei:emph">
        <em><xsl:apply-templates select="node() | @*"/></em>
    </xsl:template>
    
    <xsl:template match="tei:soCalled">
        <span class="soCalled"><xsl:apply-templates select="node() | @*"/></span>
    </xsl:template>
    
    <xsl:template match="tei:eg[tei:notatedMusic[tei:ptr]]">
        
        <xsl:variable name="sampleId" select="'s' || uuid:randomUUID()" as="xs:string"/>
        
        <xsl:variable name="sampleUri" select="(.//tei:ptr)[1]/@target" as="xs:string"/>
        <xsl:variable name="sampleFile" select="doc('../samples/' || $sampleUri)" as="node()?"/>
        
        <xsl:variable name="xpath" select="(./tei:notatedMusic/tei:desc[@type = 'xpath'])[1]/text()" as="xs:string?"/>
        
        <div class="meiSample">
            <div class="verovio" id="{$sampleId}_verovio"></div>
            <div class="btn-group">
                <button class="btn btn-sm active" id="{$sampleId}_excerpt_link" onclick="showCode('excerpt','{$sampleId}')">
                    Relevant Excerpt
                </button>
                <button class="btn btn-sm" id="{$sampleId}_full_link" onclick="showCode('full','{$sampleId}')">
                    Full Encoding
                </button>
            </div>
            <!--<ul class="tab tab-block">
                <li class="tab-item">
                    <span class="active" id="{$sampleId}_excerpt_link">Relevant Excerpt</span>
                </li>
                <li class="tab-item">
                    <span id="{$sampleId}_full_link">Full Encoding</span>
                </li>
            </ul>-->
            <div class="excerpt" id="{$sampleId}_excerpt_container">
                <div class="excerptEditor" id="{$sampleId}_excerpt">
                   <xsl:variable name="snippet">
                       <xsl:variable name="xpathQuery">doc('../samples/<xsl:value-of select="$sampleUri"/>')<xsl:value-of select="$xpath"/></xsl:variable>
                       <xsl:evaluate xpath="$xpathQuery"/> 
                   </xsl:variable>
                    <!--<xsl:result-document href="./../dist/samples/{$sampleId}_excerpt.mei" method="xml" indent="yes">
                       <xsl:apply-templates select="$snippet" mode="removeNamespace"/>
                   </xsl:result-document>-->
                    <div xml:space="preserve" class="pre">
<xsl:apply-templates select="$snippet" mode="preserveSpace"/>
                    </div>
                </div>
            </div>
            <div class="fullEncoding hide" id="{$sampleId}_full_container">
                <div class="editor" id="{$sampleId}_full">
                    
                </div>
            </div>
            <script>
                loadMEI('<xsl:value-of select="$sampleId"/>','<xsl:value-of select="$sampleUri"/>');
            </script>
        </div>
    </xsl:template>
    
    <!-- START parsing of examples to HTML -->
    <!-- in order to preserve spacing, it is important that the following template is kept on one line -->
    <xsl:template match="element()" mode="preserveSpace" priority="1">
        <xsl:param name="indent" as="xs:integer?"/>
        <xsl:variable name="indent.level" select="if($indent) then($indent) else(1)" as="xs:integer"/>
        <xsl:variable name="element" select="." as="node()"/>
        <xsl:choose>
            <xsl:when test="local-name() = 'param' and @name = 'pattern' and string-length(text()) gt 30">
                <div class="indent{$indent.level}"><span data-indentation="{$indent.level}" class="element">&lt;<xsl:value-of select="name($element)"/><xsl:apply-templates select="$element/@*" mode="#current"/>&gt;</span>
                    <xsl:choose>
                        <xsl:when test="string-length(text()) gt 240">
                            <div class="indent{$indent.level + 1}"><xsl:value-of select="substring(text(),1,60)"/></div>
                            <div class="indent{$indent.level + 2}"><xsl:value-of select="substring(text(),61,60)"/></div>
                            <div class="indent{$indent.level + 2}"><xsl:value-of select="substring(text(),121,60)"/></div>
                            <div class="indent{$indent.level + 2}"><xsl:value-of select="substring(text(),181,60)"/></div>
                            <div class="indent{$indent.level + 2}"><xsl:value-of select="substring(text(),241,60)"/></div>
                        </xsl:when>
                        <xsl:when test="string-length(text()) gt 180">
                            <div class="indent{$indent.level + 1}"><xsl:value-of select="substring(text(),1,60)"/></div>
                            <div class="indent{$indent.level + 2}"><xsl:value-of select="substring(text(),61,60)"/></div>
                            <div class="indent{$indent.level + 2}"><xsl:value-of select="substring(text(),121,60)"/></div>
                            <div class="indent{$indent.level + 2}"><xsl:value-of select="substring(text(),181,60)"/></div>
                        </xsl:when>
                        <xsl:when test="string-length(text()) gt 120">
                            <div class="indent{$indent.level + 1}"><xsl:value-of select="substring(text(),1,60)"/></div>
                            <div class="indent{$indent.level + 2}"><xsl:value-of select="substring(text(),61,60)"/></div>
                            <div class="indent{$indent.level + 2}"><xsl:value-of select="substring(text(),121,60)"/></div>
                        </xsl:when>
                        <xsl:when test="string-length(text()) gt 60">
                            <div class="indent{$indent.level + 1}"><xsl:value-of select="substring(text(),1,60)"/></div>
                            <div class="indent{$indent.level + 2}"><xsl:value-of select="substring(text(),61,60)"/></div>
                        </xsl:when>
                        <xsl:when test="string-length(text()) gt 30">
                            <div class="indent{$indent.level + 1}"><xsl:value-of select="substring(text(),1,100)"/></div>        
                        </xsl:when>
                    </xsl:choose>
                    <span data-indentation="{$indent.level}" class="element">&lt;/<xsl:value-of select="name($element)"/>&gt;</span></div>
            </xsl:when>
            <xsl:otherwise>
                <div class="indent{$indent.level}"><span data-indentation="{$indent.level}" class="element">&lt;<xsl:value-of select="name($element)"/><xsl:apply-templates select="$element/@*" mode="#current"/><xsl:if test="not($element/node())">/</xsl:if>&gt;</span><xsl:apply-templates select="$element/node()" mode="#current"><xsl:with-param name="indent" select="$indent.level + 1" as="xs:integer"/></xsl:apply-templates><xsl:if test="$element/node()"><span data-indentation="{$indent.level}" class="element">&lt;/<xsl:value-of select="name($element)"/>&gt;</span></xsl:if></div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- in order to preserve spacing, it is important that the following template is kept on one line -->
    <xsl:template match="comment()" mode="preserveSpace" priority="1">
        <xsl:param name="indent" as="xs:integer?"/>
        <xsl:variable name="indent.level" select="if($indent) then($indent) else(1)" as="xs:integer"/>
        <xsl:variable name="element" select="." as="node()"/>
        <div class="indent{$indent.level}"><span data-indentation="{$indent.level}" class="comment">&lt;!--<xsl:value-of select="."/>--&gt;</span></div>   
    </xsl:template>
    
    <!-- in order to preserve spacing, it is important that the following template is kept on one line -->
    <xsl:template match="@*" mode="preserveSpace" priority="1"><xsl:value-of select="' '"/><span class="attribute"><xsl:value-of select="name()"/>=</span><span class="attributevalue">"<xsl:value-of select="string(.)"/>"</span></xsl:template>
    
    <!-- STOP parsing of examples to HTML -->
    
    <xsl:template match="element()" priority="1" mode="removeNamespace">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="node() | @*" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>