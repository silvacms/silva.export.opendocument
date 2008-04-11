
# Zope 3
from zope.interface import implements
from zope.component import adapts

# Zope 2
import Globals
from AccessControl import ModuleSecurityInfo, ClassSecurityInfo

# Silva
from Products.Silva.adapters import adapter, interfaces
from Products.Silva import interfaces as silva_interfaces
from Products.Silva import SilvaPermissions

from pkg_resources import resource_stream, Requirement
from lxml.etree import ElementTree, XML

class OpenDocumentExportAdapter(adapter.Adapter):
    """Adapter to export Silva Object to OpenDocument
    """
    
    implements(interfaces.IContentExporter)
    adapts(silva_interfaces.ISilvaObject)
    
    security = ClassSecurityInfo()

    name = "Open Document"
    extension = "odt"

    def _getXSLT(self):
        req = Requirement.parse('silva.export.opendocument')
        stream = resource_stream(req, 'silva2odt.xslt')
        return ElementTree(XML(stream.read()))

    security.declareProtected(
        SilvaPermissions.ChangeSilvaContent, 'export')    
    def export(self, settings=None):
        from Products.Silva.silvaxml import xmlexport

        # export context to xml
        if settings == None:
            settings = xmlexport.ExportSettings()
        exporter = xmlexport.theXMLExporter
        info = xmlexport.ExportInfo()
        exportRoot = xmlexport.SilvaExportRoot(self.context)

        xml_export = exporter.exportToString(exportRoot, settings, info)
        
        # now transform the XML
        xml_export = ElementTree(XML(xml_export))
        style_doc = self._getXSLT()

        # TODO
        return as_xml


Globals.InitializeClass(OpenDocumentExportAdapter)
