<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:u2="https://doi.org/10.5065/D6KD1WN0">

    <xsl:output method="html" indent="yes"/>

    <xsl:template match="/">
        <html lang="en">
        <head>
            <meta charset="UTF-8"/>
            <title>UDUNITS-2 units database </title>
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
                    line-height: 1.6;
                    max-width: 1200px;
                    margin: 0 auto;
                    padding: 20px;
                    background-color: #f5f5f5;
                }
                .header {
                    background-color: #fff;
                    padding: 20px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                }
                .unit-card {
                    background-color: white;
                    border-radius: 8px;
                    padding: 20px;
                    margin-bottom: 20px;
                    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                }
                .unit-header {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    margin-bottom: 15px;
                    border-bottom: 2px solid #4a90e2;
                    padding-bottom: 10px;
                }
                .unit-info {
                    display: flex;
                    align-items: center;
                    flex: 1;
                }
                .unit-name {
                    font-size: 1.5em;
                    font-weight: bold;
                    margin-right: 15px;
                }
                .unit-plural {
                    font-size: 1.1em;
                    margin-right: 15px;
                }
                .unit-symbol {
                    font-size: 1.2em;
                    color: #4a90e2;
                    font-weight: bold;
                    padding: 3px 8px;
                    border: 2px solid #4a90e2;
                    border-radius: 4px;
                }
                .unit-aliases {
                    color: #666;
                    font-style: italic;
                    margin-left: 15px;
                }
                .unit-derived { 
                    font-style: italic; 
                    margin-left: 15px;
                }
                .unit-comment {
                    color: #718096;
                    font-size: 0.9em;
                    font-style: normal;
                    margin-left: 15px;
                    text-align: right;
                    flex-shrink: 0;
                }
                .unit-definition {
                    color: #333;
                    font-size: 1.1em;
                    line-height: 1.6;
                }
                .copyright {
                    margin-top: 20px;
                    font-size: 0.9em;
                    color: #666;
                    text-align: center;
                    padding: 20px;
                    background-color: white;
                    border-radius: 8px;
                    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                }
            </style>
        </head>
        <body>
            <!-- Process Base Units -->
            <xsl:if test="//unit[base]">
                <div class="header">
                    <h1>SI Base Units</h1>
                    <p>The seven fundamental units of the International System of Units (SI)</p>
                </div>
                <xsl:apply-templates select="//unit[base]"/>
            </xsl:if>

            <!-- Process SI Derived Units -->
            <xsl:if test="//unit[comment[text() = 'SI derived unit']]">
                <div class="header">
                    <h1>SI Derived Units</h1>
                </div>
                <xsl:apply-templates select="//unit[comment[text() = 'SI derived unit']]"/>
            </xsl:if>

            <!-- Process SI Derived Units with Special Names -->
            <xsl:if test="//unit[comment[text()[starts-with(., 'SI derived unit with special')]]]">
                <div class="header">
                    <h1>SI Derived Units with Special Names</h1>
                    <p>SI derived units with special names/symbols admitted for reasons of safeguarding human health</p>
                </div>
                <xsl:apply-templates select="//unit[comment[text()[starts-with(., 'SI derived unit with special')]]]"/>
            </xsl:if>

            <!-- Process Other Units -->
            <xsl:if test="//unit[not(base) and not(comment[text()[starts-with(., 'SI derived unit')]])]">
                <div class="header">
                    <h1>Units Accepted for Use with SI</h1>
                </div>
                <xsl:apply-templates select="//unit[not(base) and not(comment[text()[starts-with(., 'SI derived unit')]])]"/>
            </xsl:if>

            <!--
            <xsl:if test="//unit[not(base) and not(comment[text()[starts-with(., 'SI derived unit')]])]">
                <div class="header">
                    <h1>Units Accepted for Use with SI</h1>
                </div>
                <xsl:apply-templates select="//unit[not(base) and not(comment)]"/>
            </xsl:if>
            <div class="copyright">
                <p>
                    Web pages derived from the XML database of units in the UDUNITS-2 package.<br/>
                    The UDUNITS-2 package is copyrighted by the University Corporation for Atmospheric Research, 2020.
                </p>
            </div>
            -->
        </body>
        </html>
    </xsl:template>

    <xsl:template match="unit">
        <div class="unit-card">
            <div class="unit-header">
                <div class="unit-info">
                    <span class="unit-name">
                        <xsl:choose>
                            <xsl:when test="name/singular">
                                <xsl:value-of select="name/singular"/>
                            </xsl:when>
                            <xsl:when test="aliases/name/singular">
                                <xsl:value-of select="aliases/name/singular"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <em>Unnamed unit</em>
                            </xsl:otherwise>
                        </xsl:choose>
                    </span>
                    <xsl:if test="name/plural or aliases/name/plural">
                        <span class="unit-plural">
                            (plural: 
                            <xsl:choose>
                                <xsl:when test="name/plural">
                                    <xsl:value-of select="name/plural"/>
                                </xsl:when>
                                <xsl:when test="aliases/name/plural">
                                    <xsl:value-of select="aliases/name/plural"/>
                                </xsl:when>
                            </xsl:choose>
                            )
                        </span>
                    </xsl:if>

                    <span class="unit-symbol">
                        <xsl:choose>
                            <xsl:when test="symbol">
                                <xsl:for-each select="symbol">
                                    <xsl:value-of select="."/>
                                    <xsl:if test="position() != last()">, </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="aliases/symbol">
                                <xsl:for-each select="aliases/symbol">
                                    <xsl:value-of select="."/>
                                    <xsl:if test="position() != last()">, </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="name/singular">
                                        <xsl:value-of select="name/singular"/>
                                    </xsl:when>
                                    <xsl:when test="aliases/name/singular">
                                        <xsl:value-of select="aliases/name/singular"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <em>No symbol</em>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </span>
                    <xsl:if test="def">
                        <span class="unit-derived">
                            Derived from: <xsl:value-of select="def"/>
                        </span>
                    </xsl:if>
                </div>
                <xsl:if test="comment">
                    <span class="unit-comment">
                        <xsl:value-of select="comment"/>
                    </span>
                </xsl:if>
                <xsl:if test="base">
                    <span class="unit-comment">
                        SI base unit
                    </span>
                </xsl:if>

            </div>

            <div class="unit-definition">
                <xsl:call-template name="capitalize">
                    <xsl:with-param name="text" select="definition"/>
                </xsl:call-template>
            </div>
        </div>
    </xsl:template>

    <!-- Helper template to capitalize first letter -->
    <xsl:template name="capitalize">
        <xsl:param name="text"/>
        <xsl:value-of select="concat(
            translate(substring($text, 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
            substring($text, 2))"/>
    </xsl:template>

</xsl:stylesheet>
