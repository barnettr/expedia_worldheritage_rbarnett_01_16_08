<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output omit-xml-declaration="no" method="html" indent="yes"/>
  <xsl:key name="distinct-reg" match="region" use="." />  
  <xsl:key name="distinct-state" match="state" use="." />
  <xsl:key name="group-reg" match="row" use="region" />  
  <xsl:key name="group-state" match="row" use="state" />
  <xsl:param name="region" />
  <xsl:param name="state" />
  <xsl:param name="page" />
  <xsl:param name="pview" />
  <xsl:param name="maxPages" />
  <xsl:param name="SortCol" />
  <xsl:param name="SortDir" />
  <xsl:param name="SortType" />
  <xsl:template match="worldheritage">
  <style type="text/css">
      #grid
      {
      width: 100%;
      border-collapse: collapse;
      }
      .gridRow
      {
      background-color:#ffffff;
      line-height:19px;
      font-family: Trebuchet MS, arial, helvetica, sans serif;
      font-size: 11px;
      font-weight: bold;
      cursor: pointer;
      }
      html>body .gridRow
      {
      line-height:18px;
      }
      .gridRowHover
      {
      line-height:19px;
      background-color: #e7eff7;
      }
      html>body .gridRowHover
      {
      line-height: 18px;
      }
      .gridRow a
      {
      color: #4985c7;
      text-decoration: none;
      }
      .gridRowHover a
      {
      color: #4985c7;
      text-decoration: underline;
      }
      .gridIcon
      {
      background-image: url(http://media.expedia.com/media/content/expus/graphics/promos/deals/wh_grid_button.gif);
      background-repeat: no-repeat;
      height: 20px;
      padding-top: 0px;
      width: 24px;
      }
      .gridIconCell
      {
      font-family: Trebuchet MS,arial,sans-serif;
      font-size: 11px;
      font-weight: bold;
      color: #ffffff;
      padding-left: 4px;
      text-align: center;
      border-bottom: 1px dotted #e0dfdf;
      }
      .gridIconOff
      {
      background-image: url(http://media.expedia.com/media/content/expus/graphics/promos/deals/wh_grid_button_selected.gif);
      background-repeat: no-repeat;
      color: #cc6600;
      height: 20px;
      padding-top: 0px;
      width: 24px;
      }
      .gridLocCell
      {
      padding-bottom:4px;
      padding-top:3px;
      padding-left:5px;
      padding-right:4px;
      font-family: Trebuchet MS, arial, helvetica, sans serif;
      font-size: 11px;
      color: #666666;
      font-weight: bold;
      cursor:pointer;
      text-decoration:none;
      border-bottom: 1px dotted #e0dfdf;
      }
      .gridLocCell img
      {
      padding-left: 4px;
      margin-left: 4px;
      }
      html>body .gridLocCell img
      {
      margin-left: 0;
      }
      .gridLocCell a:hover
      {
      color: #4985c7;
      text-decoration: underline;
      }
      #pagination
      {
      background-color: #ffffff;
      color: #333333;
      font-family: Trebuchet MS,arial,sans-serif;
      font-size: 11px;
      font-weight: bold;
      margin-top:2px;
      padding-bottom: 4px;
      padding-left: 4px;
      padding-top: 4px;
      text-align: left;
      border-bottom: 1px dotted #e0dfdf;
      }
      #nopagination
      {
      margin-top:2px;
      padding-bottom: 4px;
      padding-top: 4px;
      border-bottom: 1px dotted #e0dfdf;
      height: 6px;
      }
      #pagination img
      {
      padding: 0 4px;
      margin: 0 4px;
      }
      html>body #pagination img
      {
      margin: 0;
      }
      #pagination a
      {
      color: #4985c7;
      font-weight: bold;
      text-decoration: none;
      }
      #pagination .pagingdisabled
      {
      color: #999999;
      }
      #pagination a:hover, #pagination a:active
      {
      text-decoration: none;
      }
  </style>	
  <script type="text/javascript">
	function setPageView(type,opt) {
		var url;
		var qs = new String(window.location);
		var pview = /pview\=\d+/i;
		var page = /page\=\d+/i;
		if (qs.split('?')[1] == undefined) {
			url = (type=='pview')?qs+'?pview='+opt:qs+'?page='+opt;
		} else {
			if (type=='pview') {
				url = (qs.match(pview)!=null) ? qs.replace(pview,'pview='+opt) : qs+'&amp;pview='+opt;
				url = url.replace(page,'page=1');				
			} else {
				url = (qs.match(page)!=null) ? qs.replace(page,'page='+opt) : qs+'&amp;page='+opt;
			}
		}
		document.location=url;
	}
	
	function doSort(col) {
		var url;
		var qs = new String(window.location);
		var sortCol = /sortCol\=[a-z0-9]+/i;
		var sortDir = /sortDir\=[a-z]+/i;
		var page = /page\=\d+/i;		
		if (qs.split('?')[1] == undefined) {
			url = qs+'?sortCol='+col+'&amp;sortDir=descending';
		} else {
			if (qs.match(sortCol)!=null) {
				var curSortCol = qs.match(sortCol);
				var curSortDir = qs.match(sortDir);
				var selSortCol = 'sortCol='+col;
				var selSortDir = (curSortDir=='sortDir=ascending')?'sortDir=descending':'sortDir=ascending';
				url = (curSortCol==selSortCol)?qs.replace(sortDir,selSortDir):qs.replace(sortCol,selSortCol).replace(sortDir,'sortDir=ascending');
			} else {
				url = qs+'&amp;sortCol='+col+'&amp;sortDir=descending';
			}
		}
		url = url.replace(page,'page=1');
		document.location=url;
	}
	
	var CurrentState;
	</script>
  <table id="grid">
      <tr>
          <td colspan="2" id="nopagination"></td>
      </tr>
    <xsl:for-each select="row">	    
            	<xsl:call-template name="grid" />  
    </xsl:for-each>
	</table>
  </xsl:template>
  <!-- BEGIN PRICE GRID --> 
  <xsl:template name="grid">
    <tr>
        <xsl:attribute name="onclick">window.location='sites.asp?region=<xsl:value-of select="region" />&amp;locid=<xsl:value-of select="@id" />';</xsl:attribute>
        <xsl:attribute name="id">row_<xsl:value-of select="position()" /></xsl:attribute>
        <xsl:attribute name="onmouseover">GridShowInfoBox(getPinID(<xsl:value-of select="position()" />));showRow('<xsl:value-of select="position()" />','row');</xsl:attribute>
        <xsl:attribute name="onmouseout">GridHideInfoBox(getPinID(<xsl:value-of select="position()" />));hideRow('<xsl:value-of select="position()" />','row');</xsl:attribute>
        <xsl:attribute name="class">gridRow</xsl:attribute>
      <td>
        <xsl:attribute name="class">gridIconCell</xsl:attribute>
        <script type="text/javascript">
          //Create an object with these properties then add to array
          //BuildPushpin(id,region,site,location,state,suitcase,flag,desc,img,lat,lng,locid)
          var pin = new Object();
          pin.locid = "<xsl:value-of select="@id" />";
          pin.region = "<xsl:value-of select="region" />";
          pin.id = "<xsl:value-of select="position()" />";
          pin.site = "<xsl:value-of select="site" />";
          pin.location = "<xsl:value-of select="substring(location,0,32)" disable-output-escaping="yes" /><xsl:if test="string-length(location) > 31">...</xsl:if>";
          pin.state = "<xsl:value-of select="state" />";
          pin.suitcase = "";
          pin.flag = "http://whc.unesco.org/uploads/states/small/<xsl:value-of select="code" />.gif";
          pin.desc = "<xsl:value-of select="description" />";
          pin.img = "http://whc.unesco.org/uploads/sites/site_<xsl:value-of select="@id" />.jpg";
          pin.lat = "<xsl:value-of select="@lat" />";
          pin.lng = "<xsl:value-of select="@long" />";
          arrPin[pinid] = pin;
          pinid++;
        </script>
        <div class="gridIcon" onmouseover="this.className='gridIconOff';"  onmouseout="this.className='gridIcon';">
        <xsl:attribute name="id">gridIcon_<xsl:value-of select="position()" /></xsl:attribute>
        <xsl:value-of select="position()" />
        </div>
      </td>
      <td>
        <xsl:attribute name="class">gridLocCell</xsl:attribute>
        <a>
          <xsl:attribute name="href">sites.asp?region=<xsl:value-of select="region" />&amp;locid=<xsl:value-of select="@id" /></xsl:attribute>
            <xsl:attribute name="target">_top</xsl:attribute>
          <span><xsl:attribute name="title"><xsl:value-of select="site" /></xsl:attribute><xsl:value-of select="substring(site,0,39)" disable-output-escaping="yes" /><xsl:if test="string-length(site) > 38">...</xsl:if><img><xsl:attribute name="src">http://media.expedia.com/media/content/expus/graphics/promos/other/wh_grid_arrow.gif</xsl:attribute></img></span>
        </a>
        <br />
        <xsl:choose>
          <xsl:when test="location != ''">
              <xsl:variable name="locstate"><xsl:value-of select="location" />, <xsl:value-of select="state" /></xsl:variable>
                <xsl:attribute name="title"><xsl:value-of select="$locstate" /></xsl:attribute>
                <xsl:value-of select="substring($locstate,0,40)" disable-output-escaping="yes" />
                <xsl:if test="string-length($locstate) > 39">...</xsl:if>
          </xsl:when>
          <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
        <br />
      </td>
    </tr>
    </xsl:template>  
  <!-- END PRICE GRID -->
</xsl:stylesheet>
