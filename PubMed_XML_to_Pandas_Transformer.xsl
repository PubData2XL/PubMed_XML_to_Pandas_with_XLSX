<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  
  <xsl:template match="PubmedArticleSet | PubmedBookArticleSet">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="PubmedArticle | PubmedBookArticle | DeleteCitation">
    <xsl:element name="Citation">
      <xsl:element name="Order">
          <xsl:number count="PubmedArticle | PubmedBookArticle | DeleteCitation" from="PubmedArticleSet | PubmedBookArticleSet" level="any"/>
      </xsl:element>
      <xsl:apply-templates select="MedlineCitation"/>
      <xsl:apply-templates select="PubmedData"/>
      <xsl:apply-templates select="BookDocument"/>
      <xsl:apply-templates select="PubmedBookData"/>
      <xsl:copy-of select='PMID'/>
    </xsl:element>
  </xsl:template>
  
  <!-- All Date type fields -->
  <xsl:template match="DateCompleted | DateRevised | PubDate | ArticleDate | PubMedPubDate | BeginningDate | EndingDate | ContributionDate">
    <xsl:variable name="date_element"><xsl:value-of select ="name(.)"/><xsl:if test="@PubStatus != ''"><xsl:value-of select ="concat('_', @PubStatus)"/></xsl:if></xsl:variable>
    <xsl:variable name="date_type"><xsl:if test="@DateType != ''"><xsl:value-of select ="concat('_', @DateType)"/></xsl:if></xsl:variable>
    <xsl:variable name="Year"><xsl:if test="Year != ''"><xsl:value-of select ="Year"/></xsl:if></xsl:variable>
    <xsl:variable name="Month"><xsl:if test="Month != ''"><xsl:value-of select ="concat('-', Month)"/></xsl:if></xsl:variable>
    <xsl:variable name="Day"><xsl:if test="Day != ''"><xsl:value-of select ="concat('-', Day)"/></xsl:if></xsl:variable>
    <xsl:variable name="Hour"><xsl:if test="Hour != ''"><xsl:value-of select ="concat(' ', Hour)"/></xsl:if></xsl:variable>
    <xsl:variable name="Minute"><xsl:if test="Minute != ''"><xsl:value-of select ="concat(':', Minute)"/></xsl:if></xsl:variable>
    <xsl:variable name="Second"><xsl:if test="Second != ''"><xsl:value-of select ="concat(':', Second)"/></xsl:if></xsl:variable>
    <xsl:variable name="Season"><xsl:if test="Season != ''"><xsl:value-of select ="concat('-', Season)"/></xsl:if></xsl:variable>
    
    <xsl:element name="{concat($date_element, $date_type)}">
      <xsl:value-of select ="concat($Year, $Month, $Day, $Season, $Hour, $Minute, $Second)"/>
    </xsl:element>
  </xsl:template>

  <!-- MedlineCitation -->
  <xsl:template match="MedlineCitation">
    <xsl:element name="Type">PubmedArticle</xsl:element>
    <xsl:element name="Status">
      <xsl:value-of select="@Status"/>
    </xsl:element>
    <xsl:element name="IndexingMethod">
      <xsl:value-of select="@IndexingMethod"/>
    </xsl:element>
    <xsl:element name="Owner">
      <xsl:value-of select="@Owner"/>
    </xsl:element>
    <xsl:copy-of select='PMID'/>
    <xsl:apply-templates select="DateCompleted"/>
    <xsl:apply-templates select="DateRevised"/>
    <xsl:apply-templates select="Article"/>
    <xsl:apply-templates select="MedlineJournalInfo"/>
    <xsl:apply-templates select="ChemicalList"/>
    <xsl:apply-templates select="SupplMeshList"/>
    <xsl:copy-of select='CitationSubset'/>
    <xsl:apply-templates select="CommentsCorrectionsList"/>
    <xsl:apply-templates select="GeneSymbolList"/>
    <xsl:apply-templates select="MeshHeadingList"/>
    <xsl:copy-of select="NumberOfReferences"/>
    <xsl:apply-templates select="PersonalNameSubjectList"/>
    <xsl:apply-templates select="OtherID"/>
    <xsl:apply-templates select="OtherAbstract"/>
    <xsl:apply-templates select="KeywordList"/>    
    <xsl:copy-of select='CoiStatement'/>
    <xsl:element name="SpaceFlightMission">
      <xsl:for-each select="SpaceFlightMission">
        <xsl:if test="position() != 1">||</xsl:if>
        <xsl:value-of select='concat("{SpaceFlightMission|:| ", text(),"}")'/>
      </xsl:for-each>
    </xsl:element>
    <xsl:apply-templates select="InvestigatorList"/>
    <xsl:apply-templates select="GeneralNote"/>
  </xsl:template>

  <xsl:template match="Article">
    <xsl:element name="PubModel">
      <xsl:value-of select="@PubModel"/>
    </xsl:element>
    <xsl:apply-templates select="Journal"/>
    <xsl:element name="ArticleTitle">
      <xsl:apply-templates select="ArticleTitle"/>
    </xsl:element>
    <xsl:copy-of select='VernacularTitle'/> 
    <xsl:element name="ELocationID"><xsl:apply-templates select="ELocationID" /></xsl:element>
    <xsl:apply-templates select="Pagination"/>
    <xsl:apply-templates select="Abstract"/>
    <xsl:apply-templates select="AuthorList"/>
    <xsl:element name="Language">
      <xsl:for-each select="Language">
        <xsl:if test="position() != 1">||</xsl:if>
        <xsl:value-of select='text()'/>
      </xsl:for-each>
    </xsl:element>
    <xsl:apply-templates select="GrantList"/> 
    <xsl:apply-templates select="PublicationTypeList"/>
    <xsl:apply-templates select="ArticleDate"/>
  </xsl:template>

  <xsl:template match="PublicationType">
    <xsl:if test="position() != 1">||</xsl:if>
    <xsl:value-of select='concat("PublicationType|:| ", text(), "|,| UI|:| ", @UI)'/>
  </xsl:template>

  <xsl:template match="PublicationTypeList">
    <xsl:element name="PublicationTypeList">
      <xsl:apply-templates select="PublicationType"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ELocationID">
    <xsl:if test="position() != 1">||</xsl:if>
    <xsl:value-of select='concat(@EIdType,": ", text())'/>
  </xsl:template>

  <xsl:template match="MedlineJournalInfo">
    <xsl:element name="Journal_Country">
      <xsl:value-of select='Country'/>
    </xsl:element>
    <xsl:copy-of select='MedlineTA'/>
    <xsl:copy-of select='NlmUniqueID'/>
    <xsl:copy-of select='ISSNLinking'/>
  </xsl:template>

  <xsl:template match="Pagination">
    <xsl:element name="Pagination">
      <xsl:choose>
        <xsl:when test="MedlinePgn != ''">
          <xsl:value-of select="MedlinePgn"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="StartPage != ''">
              <xsl:value-of select="StartPage"/>
              <xsl:if test="EndPage != ''">
                <xsl:value-of select="concat('-', EndPage)"/>
              </xsl:if>
            </xsl:when>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="Journal">
    <xsl:element name="JournalTitle"><xsl:value-of select="Title"/></xsl:element>
    <xsl:copy-of select="ISOAbbreviation"/>
    <xsl:variable name="ISSN" select="concat('ISSN_', ISSN/@IssnType)"/>
    <xsl:element name='{$ISSN}'><xsl:value-of select="ISSN"/></xsl:element>
    <xsl:copy-of select="JournalIssue/Volume"/>
    <xsl:copy-of select="JournalIssue/Issue"/>
    <xsl:apply-templates select="JournalIssue/PubDate"/>
  </xsl:template>

  <xsl:template match="Abstract | OtherAbstract">
    <xsl:element name="{name(.)}">
      <xsl:copy-of select='@Type'/>
      <xsl:copy-of select='@Language'/>
      <xsl:for-each select="AbstractText">
        <xsl:if test="@Label">
          <xsl:choose>
            <xsl:when test="position() = 1">
              <xsl:value-of select='concat(@Label,": ")'/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select='concat(" \n ", @Label,": ")'/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <xsl:value-of select='text()'/>
      </xsl:for-each>
    </xsl:element>
    <xsl:copy-of select='CopyrightInformation'/>
  </xsl:template>

  <xsl:template match="Author | Investigator | PersonalNameSubject">
    <xsl:variable name="CollectiveName"><xsl:if test="CollectiveName != ''"><xsl:value-of select ='concat("|,| CollectiveName|:| ", CollectiveName)'/></xsl:if></xsl:variable>
    <xsl:variable name="LastName"><xsl:if test="LastName != ''"><xsl:value-of select ='concat("|,| LastName|:| ", LastName)'/></xsl:if></xsl:variable>
    <xsl:variable name="ForeName"><xsl:if test="ForeName != ''"><xsl:value-of select ='concat("|,| ForeName|:| ", ForeName)'/></xsl:if></xsl:variable>
    <xsl:variable name="FullName">
      <xsl:text>|,| FullName|:| </xsl:text>
      <xsl:if test="CollectiveName != ''"><xsl:value-of select ='CollectiveName'/></xsl:if>
      <xsl:if test="LastName != ''"><xsl:value-of select ='LastName'/></xsl:if>
      <xsl:if test="ForeName != ''"><xsl:value-of select ='concat(", ", ForeName)'/></xsl:if>
    </xsl:variable>
    <xsl:variable name="Initials"><xsl:if test="Initials != ''"><xsl:value-of select ='concat("|,| Initials|:| ", Initials)'/></xsl:if></xsl:variable>
    <xsl:variable name="Suffix"><xsl:if test="Suffix != ''"><xsl:value-of select ='concat("|,| Suffix|:| ", Suffix)'/></xsl:if></xsl:variable>
    <xsl:variable name="Identifier"><xsl:if test="Identifier != ''"><xsl:value-of select ='concat("|,| ", Identifier/@Source, "|:| ", Identifier)'/></xsl:if></xsl:variable>
    <xsl:variable name="AffiliationInfo">
      <xsl:text>|,| Affiliation|:| </xsl:text>
      <xsl:if test="not(AffiliationInfo)">not available</xsl:if>
      <xsl:for-each select="AffiliationInfo">
        <xsl:if test="position() != 1"> |AND| </xsl:if>
        <xsl:value-of select ='Affiliation'/>
      </xsl:for-each>
      <xsl:text></xsl:text>
    </xsl:variable>
    <xsl:if test="position() != 1">||</xsl:if>
    <xsl:value-of select='concat("Position|:| ", position(), $FullName, $CollectiveName, $LastName, $ForeName, $Initials, $Suffix, $Identifier, $AffiliationInfo)'/>
  </xsl:template>

  <xsl:template match="AuthorList | InvestigatorList | PersonalNameSubjectList">
    <xsl:element name="{name(.)}">
      <xsl:apply-templates select="Author | Investigator | PersonalNameSubject"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Grant">
    <xsl:variable name="GrantID"><xsl:if test="GrantID != ''"><xsl:value-of select ='concat("|,| GrantID|:| ", GrantID)'/></xsl:if></xsl:variable>
    <xsl:variable name="Acronym"><xsl:if test="Acronym != ''"><xsl:value-of select ='concat("|,| Acronym|:| ", Acronym)'/></xsl:if></xsl:variable>
    <xsl:variable name="Agency"><xsl:if test="Agency != ''"><xsl:value-of select ='concat("|,| Agency|:| ", Agency)'/></xsl:if></xsl:variable>
    <xsl:variable name="Country"><xsl:if test="Country != ''"><xsl:value-of select ='concat("|,| Country|:| ", Country)'/></xsl:if></xsl:variable>
    <xsl:if test="position() != 1">||</xsl:if>
    <xsl:value-of select='concat("Position|:| ", position(), $GrantID, $Acronym, $Agency, $Country)'/>
  </xsl:template>

  <xsl:template match="GrantList">
    <xsl:element name="GrantList">
      <xsl:apply-templates select="Grant"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="MeshHeadingList">
    <xsl:element name="MeshHeadingList">
      <xsl:for-each select="MeshHeading">
        <xsl:variable name="DescriptorName"><xsl:value-of select ='concat("DescriptorName|:| ", DescriptorName, "|,| UI|:| ", DescriptorName/@UI, "|,| MajorTopicYN|:| ", DescriptorName/@MajorTopicYN)'/></xsl:variable>
        <xsl:variable name="QualifierName"><xsl:for-each select="QualifierName"><xsl:value-of select ='concat("|,| QualifierName|:| ", text(), "|,| QUI|:| ", @UI, "|,| QMajorTopicYN|:| ", @MajorTopicYN)'/></xsl:for-each></xsl:variable>
        <xsl:if test="position() != 1">||</xsl:if>
        <xsl:value-of select='concat($DescriptorName, $QualifierName)'/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="SupplMeshList">
    <xsl:element name="SupplMeshList">
      <xsl:for-each select="SupplMeshName">
        <xsl:if test="position() != 1">||</xsl:if>
        <xsl:value-of select='concat("SupplMeshName|:| ", text(), "|,| UI|:| ", @UI, "|,| Type|:| ", @Type)'/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="KeywordList">
    <xsl:element name="KeywordList">
      <xsl:copy-of select='@Owner'/>      
      <xsl:for-each select="Keyword">
        <xsl:if test="position() != 1">||</xsl:if>
        <xsl:value-of select='concat("Keyword|:| ", text(), "|,| MajorTopicYN|:| ", @MajorTopicYN)'/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="OtherID">
    <xsl:element name="OtherID">
      <xsl:value-of select ='concat("OtherID|:| ", text(), "|,| Source|:| ", @Source)'/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="GeneralNote">
    <xsl:element name="GeneralNote">
      <xsl:value-of select='concat("Owner|:| ", @Owner,"|,| GeneralNote|:| ", text())'/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ChemicalList">
    <xsl:element name="ChemicalList">
      <xsl:for-each select="Chemical">
        <xsl:if test="position() != 1">||</xsl:if>
        <xsl:value-of select='concat("NameOfSubstance|:| ", NameOfSubstance/text(), "|,| RegistryNumber|:| ", RegistryNumber, "|,| UI|:| ", NameOfSubstance/@UI)'/> 
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="CommentsCorrectionsList">
    <xsl:element name="CommentsCorrectionsList">
      <xsl:for-each select="CommentsCorrections">
        <xsl:if test="position() != 1">||</xsl:if>
        <xsl:value-of select='concat("RefType|:| ", @RefType, "|,| PMID|:| ", PMID, "|,| RefSource|:| ", RefSource/text())'/> 
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="GeneSymbolList">
    <xsl:element name="{name(.)}">
      <xsl:for-each select="GeneSymbol">
        <xsl:if test="position() != 1">||</xsl:if>
        <xsl:value-of select='concat("GeneSymbol|:| ", text())'/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <!-- End MedlineCitation -->
  
  <!-- PubmedData and PubmedBookData -->

  <xsl:template match="PubmedData | PubmedBookData">
    <xsl:apply-templates select="History/PubMedPubDate"/>
    <xsl:copy-of select="PublicationStatus"/>    
    <xsl:apply-templates select="ArticleIdList"/>
    <xsl:apply-templates select="ObjectList"/>
    <xsl:apply-templates select="ReferenceList"/>
  </xsl:template>

  <xsl:template match="ReferenceList">
    <xsl:element name="ReferenceList">
      <xsl:for-each select="Reference">
        <xsl:variable name="Citation"><xsl:value-of select="concat('|,| Citation|:| ', Citation)"/></xsl:variable>
        <xsl:variable name="ArticleIdList"><xsl:if test="ArticleIdList !=''">|,|</xsl:if><xsl:apply-templates select="ArticleIdList"/></xsl:variable>
        <xsl:if test="position() != 1">||</xsl:if>
        <xsl:value-of select='concat("Position|:| ", position(), $Citation, $ArticleIdList)'/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ArticleIdList">
    <xsl:element name="ArticleIdList">
      <xsl:for-each select="ArticleId">
        <xsl:if test="position() != 1">|,|</xsl:if>
        <xsl:value-of select='concat(@IdType, "|:| ", text())'/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ObjectList">
    <xsl:element name="ObjectList">
      <xsl:for-each select="Object">
        <xsl:variable name="Params"><xsl:for-each select="Param"><xsl:if test="position() != 1">||</xsl:if><xsl:value-of select ='text()'/></xsl:for-each></xsl:variable>
        <xsl:if test="position() != 1">||</xsl:if>
        <xsl:value-of select='concat(@Type, "|:| ", $Params)'/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <!-- End PubmedData and PubmedBookData-->

  <!-- BookDocument -->

  <xsl:template match="BookDocument">
    <xsl:element name="Type">PubmedBookArticle</xsl:element>
    <xsl:copy-of select='PMID'/>
    <xsl:apply-templates select="ArticleIdList"/>
    <xsl:apply-templates select="Book"/>
    <xsl:apply-templates select="LocationLabel"/>
    <xsl:element name="ArticleTitle">
      <xsl:apply-templates select="ArticleTitle"/>
    </xsl:element>
    <xsl:copy-of select='VernacularTitle'/>
    <xsl:apply-templates select="Pagination"/>
    <xsl:copy-of select='Language'/>
    <xsl:apply-templates select="AuthorList"/>
    <xsl:apply-templates select="InvestigatorList"/>
    <xsl:element name="PublicationTypeList">
      <xsl:apply-templates select="PublicationType"/>
    </xsl:element>
    <xsl:apply-templates select="Abstract"/>
    <xsl:apply-templates select="Sections"/> 
    <xsl:apply-templates select="KeywordList"/>
    <xsl:apply-templates select="ContributionDate"/>
    <xsl:apply-templates select="DateRevised"/>
    <xsl:copy-of select='CitationString'/> 
    <xsl:apply-templates select="GrantList"/>
    <xsl:apply-templates select="ItemList"/>
    <xsl:apply-templates select="ReferenceList"/>
  </xsl:template>

  <xsl:template match="LocationLabel">
    <xsl:copy-of select="."/>
    <xsl:if test="@Type != ''"><xsl:element name="LocationLabelType"><xsl:value-of select="@Type"/></xsl:element></xsl:if>
  </xsl:template>

  <xsl:template match="ArticleTitle | BookTitle | CollectionTitle | SectionTitle">
    <xsl:variable name="Title"><xsl:value-of select='concat(name(.), "|:| ", text())'/></xsl:variable>
    <xsl:variable name="BookID"><xsl:if test="@book != ''"><xsl:value-of select='concat("|,| BookID|:| ", @book)'/></xsl:if></xsl:variable>
    <xsl:variable name="SectionID"><xsl:if test="@sec != ''"><xsl:value-of select='concat("|,| SectionID|:| ", @sec)'/></xsl:if></xsl:variable>
    <xsl:variable name="PartID"><xsl:if test="@part != ''"><xsl:value-of select='concat("|,| PartID|:| ", @part)'/></xsl:if></xsl:variable>
    <xsl:value-of select='concat($Title, $BookID, $SectionID, $PartID)'/>
  </xsl:template>

  <xsl:template match="ItemList">
    <xsl:variable name="Listtype"><xsl:if test="@ListType != ''"><xsl:value-of select='concat(@ListType, "|:| ")'/></xsl:if></xsl:variable>
    <xsl:variable name="Items">
      <xsl:for-each select="Item">
        <xsl:if test="position() != 1">|,|</xsl:if>
          <xsl:value-of select="text()"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:element name="ItemList">
      <xsl:value-of select='concat($Listtype, $Items)'/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Sections">
    <xsl:element name="Sections">
      <xsl:for-each select="Section">
        <xsl:if test="position() != 1">||</xsl:if>
          <xsl:apply-templates select="SectionTitle"/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Book">
    <xsl:copy-of select="Publisher/PublisherName"/>
    <xsl:copy-of select="Publisher/PublisherLocation"/>
    <xsl:apply-templates select="BookTitle"/>
    <xsl:apply-templates select="PubDate"/>
    <xsl:apply-templates select="BeginningDate"/>
    <xsl:apply-templates select="EndingDate"/>
    <xsl:element name="BookAuthorList">
      <xsl:apply-templates select="AuthorList/Author"/>
    </xsl:element>
    <xsl:element name="BookInvestigatorList">
      <xsl:apply-templates select="InvestigatorList/Investigator"/>
    </xsl:element>
    <xsl:copy-of select="Volume"/>
    <xsl:copy-of select="VolumeTitle"/>
    <xsl:copy-of select="Edition"/>
    <xsl:apply-templates select="CollectionTitle"/>
    <xsl:copy-of select="Isbn"/>
    <xsl:element name="ELocationID"><xsl:apply-templates select="ELocationID" /></xsl:element>
    <xsl:copy-of select="Medium"/>
    <xsl:copy-of select="ReportNumber"/>
  </xsl:template>
</xsl:stylesheet>
