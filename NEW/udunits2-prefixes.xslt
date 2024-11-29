<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
<xsl:output method="html" indent="yes" encoding="UTF-8"/>

<!-- Map of regular digits to superscript digits -->
<xsl:variable name="superscript-digits">
    -=⁻;0=⁰;1=¹;2=²;3=³;4=⁴;5=⁵;6=⁶;7=⁷;8=⁸;9=⁹;
</xsl:variable>

<!-- Convert a single digit to superscript -->
<xsl:template name="to-superscript">
    <xsl:param name="digit"/>
    <xsl:value-of select="substring-before(substring-after($superscript-digits, concat($digit, '=')), ';')"/>
</xsl:template>

<!-- Convert number to superscript -->
<xsl:template name="number-to-superscript">
    <xsl:param name="number"/>
    <xsl:if test="string-length($number) > 0">
        <xsl:call-template name="to-superscript">
            <xsl:with-param name="digit" select="substring($number,1,1)"/>
        </xsl:call-template>
        <xsl:call-template name="number-to-superscript">
            <xsl:with-param name="number" select="substring($number,2)"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<!-- Format scientific notation -->
<xsl:template name="format-scientific">
    <xsl:param name="value"/>
    <xsl:text>10</xsl:text>
    <xsl:choose>
        <!-- Handle special cases for 100, 10, .1, and .01 -->
        <xsl:when test="$value = '100'">
            <xsl:call-template name="number-to-superscript">
                <xsl:with-param name="number">2</xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = '10'">
            <xsl:call-template name="number-to-superscript">
                <xsl:with-param name="number">1</xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = '.1'">
            <xsl:call-template name="number-to-superscript">
                <xsl:with-param name="number">-1</xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = '.01'">
            <xsl:call-template name="number-to-superscript">
                <xsl:with-param name="number">-2</xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <!-- Extract exponent from 1eXX format -->
            <xsl:variable name="exponent" select="substring-after($value, 'e')"/>
            <xsl:call-template name="number-to-superscript">
                <xsl:with-param name="number" select="$exponent"/>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Format decimal representation -->
<xsl:template name="format-decimal">
    <xsl:param name="value"/>
    <xsl:choose>
        <xsl:when test="$value = '100'">100</xsl:when>
        <xsl:when test="$value = '10'">10</xsl:when>
        <xsl:when test="$value = '.1'">0.1</xsl:when>
        <xsl:when test="$value = '.01'">0.01</xsl:when>
        <xsl:otherwise>
            <xsl:variable name="exponent" select="number(substring-after($value, 'e'))"/>
            <xsl:choose>
                <xsl:when test="$exponent > 0">
                    <xsl:variable name="decimal_1">
                        <xsl:value-of select="'1'" />
                        <xsl:call-template name="repeat-char">
                            <xsl:with-param name="char" select="'0'" />
                            <xsl:with-param name="count" select="$exponent" />
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:call-template name="string-replace-all">
                        <xsl:with-param name="text" select="$decimal_1" />
                        <xsl:with-param name="replace" select="'000'" />
                        <xsl:with-param name="by" select="',000'" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="decimal_1">
                        <xsl:text>0.</xsl:text>
                        <xsl:call-template name="repeat-char">
                            <xsl:with-param name="char" select="'0'" />
                            <xsl:with-param name="count" select="-$exponent - 1" />
                        </xsl:call-template>
                        <xsl:text>1</xsl:text>
                    </xsl:variable>
                    <xsl:call-template name="string-replace-all">
                        <xsl:with-param name="text" select="$decimal_1" />
                        <xsl:with-param name="replace" select="'000'" />
                        <xsl:with-param name="by" select="'000,'" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Helper template to repeat a character n times -->
<xsl:template name="repeat-char">
    <xsl:param name="char"/>
    <xsl:param name="count"/>
    <xsl:if test="$count > 0">
        <xsl:value-of select="$char"/>
        <xsl:call-template name="repeat-char">
            <xsl:with-param name="char" select="$char"/>
            <xsl:with-param name="count" select="$count - 1"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<!-- Helper to replace all occurrences of substring, see  https://stackoverflow.com/questions/3067113/xslt-string-replace -->
<xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
        <xsl:when test="$text = '' or $replace = ''or not($replace)" >
            <!-- Prevent this routine from hanging -->
            <xsl:value-of select="$text" />
        </xsl:when>
        <xsl:when test="contains($text, $replace)">
            <xsl:value-of select="substring-before($text,$replace)" />
            <xsl:value-of select="$by" />
            <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="substring-after($text,$replace)" />
                <xsl:with-param name="replace" select="$replace" />
                <xsl:with-param name="by" select="$by" />
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$text" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<xsl:template match="/">
    <html lang="en">
    <head>
        <meta charset="UTF-8"/>
        <title>Unit Prefixes</title>
        <style>
            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
                line-height: 1.6;
                max-width: 1000px;
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
            table {
                width: 100%;
                border-collapse: collapse;
                background-color: white;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                border-radius: 8px;
                overflow: hidden;
            }
            th, td {
                padding: 12px 15px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }
            th {
                background-color: #4a90e2;
                color: white;
                font-weight: 600;
            }
            tr:hover {
                background-color: #f8f9fa;
            }
            .copyright {
                margin-top: 20px;
                font-size: 0.9em;
                color: #666;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <div class="header">
            <h1>UDUNITS-2 Metric Prefixes</h1>
            <p>A comprehensive list of metric prefixes and their corresponding values and symbols.</p>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Prefix Name</th>
                    <th>Symbol</th>
                    <th>Value</th>
                    <th>Scientific Notation</th>
                    <th>Computer notation</th>
                </tr>
            </thead>
            <tbody>
                <xsl:apply-templates select="unit-system/prefix"/>
            </tbody>
        </table>

        <div class="copyright">
            <p>Copyright 2020 University Corporation for Atmospheric Research<br/>
            This data is derived from the UDUNITS-2 package.</p>
        </div>
    </body>
    </html>
</xsl:template>

<xsl:template match="prefix">
    <tr>
        <td><xsl:value-of select="name"/></td>
        <td>
            <xsl:for-each select="symbol">
                <xsl:value-of select="."/>
                <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
        </td>
        <td>
            <xsl:call-template name="format-decimal">
                <xsl:with-param name="value" select="value"/>
            </xsl:call-template>
        </td>
        <td>
            <xsl:call-template name="format-scientific">
                <xsl:with-param name="value" select="value"/>
            </xsl:call-template>
        </td>
        <td><xsl:value-of select="value"/></td>
    </tr>
</xsl:template>

</xsl:stylesheet>


