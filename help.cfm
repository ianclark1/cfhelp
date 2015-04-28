<cfsilent>
<!--- 

Copyright 2008 Christopher Dean

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 
	http://www.apache.org/licenses/LICENSE-2.0 
Unless required by applicable law or agreed to in writing, 
software distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions 
and limitations under the License.



help.cfm

This tag will create a custom label that can be used to link to a help file.  When the mouse hovers over the help
item, the cursor changes to the help icon and the color will change to tell the user that they can click for help.
Alternatively, an image can be used, but only the activeclass attribute must be used to change anything beyond the
cursor.

Several of the attributes are used only when the init attribute is set to true.  These attributes are stored in the
Application scope so you should check in your code to verify that these variables have not disappeared and if they
have, re-initialize the tag.  Some of these initialized attributes can be overwritten when they are supplied in the
normal tag call.

attributes:

color - color of text if class attribute is not specified (can be set when initing the tag and supplied every time 
as well to override the initial settings)
activecolor - color of text when help is active (can be set when initing the tag and supplied every time 
as well to override the initial settings)
class - stylesheet class of label or image.  If present, the color and activecolor attributes will be ignored. (can be set when initing the tag and supplied every time 
as well to override the initial settings)
imgurl - url to image if image is to be used.  If blank then a label will be created.  If an image is specified then
color and activecolor wil be ignored
text - text of label, blank if image
helpurl - url to help file (only used when initing the tag).
helpurlparameters - any url parameters needed for the help, must begin with ? (only used when initing the tag).
topicanchor = anchor name for help topic (topic.topic.topic..)
topictext - english version of topic anchor for display when hovering over help area
init - (true/false).  If initializing the help system, set to the true otherwise it does not need to be supplied
check - (true/false).  Check to see if the help system has been initialized, if not then initialize it.  This is good to place in an onRequest handler in case the application variable expires
windowheight - height of the document window.  Set with init but can be overwritten.
windowwidth - width of the document window. Set with init but can be overwritten.
--->


<cfparam name="attributes.init" default="false" type="boolean">
<cfparam name="attributes.check" default="false" type="boolean">

<cfif attributes.check eq true>
  
  <!--- no lock because we don't want to slow down every page, worst case it will init multiple times --->
  
  <cfif not IsDefined('application.helpinfo')>
	 <cfset attributes.init = 'true'>
  </cfif>
</cfif>
</cfsilent> 

<cfif attributes.init eq true>
   <cfparam name="attributes.helpurl" type="string">  <!--- outside cfsilent so if they cause an error because they are required we will see the error --->
   <cfsilent>
   <cfparam name="attributes.helpurlparameters" default="" type="string">
   <cfparam name="attributes.color" default="black" type="string">
   <cfparam name="attributes.activecolor" default="red" type="string">
   <cfparam name="attributes.class" default="" type="string">
   <cfparam name="attributes.activeclass" default="" type="string">
   <cfparam name="attributes.imgurl" default="" type="string">
   <cfparam name="attributes.windowheight" default="400" type="integer">
   <cfparam name="attributes.windowwidth" default="600" type="integer">
   <cfset helpinfo = StructNew()>
   <cfset helpinfo.color = attributes.color>
   <cfset helpinfo.activecolor = attributes.activecolor>
   <cfset helpinfo.class = attributes.class>
   <cfset helpinfo.activeclass = attributes.activeclass>
   <cfset helpinfo.helpurl = attributes.helpurl>
   <cfset helpinfo.helpurlparameters = attributes.helpurlparameters>
   <cfset helpinfo.windowheight = attributes.windowheight>
   <cfset helpinfo.windowwidth = attributes.windowwidth>
   <cflock name="helpinit" timeout="120">
     <cfset application.helpinfo = helpinfo>
   </cflock>
   </cfsilent>
<cfelseif attributes.check eq 'false'>
   <cfsilent>
    <cflock name="helpinit" timeout="120">
      <cfset helpinfo = application.helpinfo>
	</cflock>
    <cfparam name="attributes.color" default="#helpinfo.color#" type="string">
    <cfparam name="attributes.activecolor" default="#helpinfo.activecolor#" type="string">
    <cfparam name="attributes.class" default="#helpinfo.class#" type="string">
    <cfparam name="attributes.activeclass" default="#helpinfo.activeclass#" type="string">
    <cfparam name="attributes.windowheight" default="#helpinfo.windowheight#" type="integer">
    <cfparam name="attributes.windowwidth" default="#helpinfo.windowwidth#" type="integer">	
	<cfset mouseover = "this.style.cursor = 'help';">
	<cfset mouseout = "this.style.cursor = 'auto';">
    <cfif attributes.activeclass neq "">
	    <cfset mouseover= mouseover & "this.className = '#attributes.activeclass#'">
	<cfelse>
	    <cfset mouseover= mouseover & "this.style.color='#attributes.activecolor#'">
	</cfif>
	<cfif attributes.class neq "">
	    <cfset mouseout= mouseout & "this.className = '#attributes.class#'">
	<cfelse>
	    <cfset mouseout= mouseout & "this.style.color='#attributes.color#'">
	</cfif>
    <cfparam name="attributes.imgurl" default="" type="string">
    <cfparam name="attributes.text" default="" type="string">
	</cfsilent>
    <cfparam name="attributes.topicanchor" type="string">
    <cfparam name="attributes.topictext" type="string">
	<cfif Find("?",helpinfo.helpurl) neq 0>
	   <cfset urlext = "&topicanchor=">
	<cfelse>
	   <cfset urlext = "?topicanchor=">
	</cfif>
	<cfif attributes.imgurl eq "">
	   <cfoutput>
       <label title="Help with #attributes.topictext#" onmouseover="#mouseover#" onmouseout="#mouseout#" onclick="var x = window.open('#helpinfo.helpurl##urlext##attributes.topicanchor#','help','toolbar=no,menubar=no,resizable=yes,scrollbars=yes,width=#helpinfo.windowwidth#,height=#helpinfo.windowheight#');x.focus();return true">#attributes.text#</label>
       </cfoutput>
    <cfelse>
	   <cfoutput>
	   <img title="Help with #attributes.topictext#" alt="Help with #attributes.topictext#" src="#helpinfo.helpurl##urlext##attributes.topicanchor#" mouseover="#mouseover#" onmouseout="#mouseout#" onclick="var x = window.open('#helpinfo.helpurl#','help','toolbar=no,menubar=no,resizable=yes,scrollbars=yes,width=#helpinfo.windowwidth#,height=#helpinfo.windowheight#');x.focus();return true">
       </cfoutput>
	</cfif>
</cfif>




