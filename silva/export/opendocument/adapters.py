
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

from pkg_resources import resource_filename, Requirement
from lxml.etree import ElementTree, XML, XSLT, tostring

from cStringIO import StringIO
from zipfile import ZipFile


def fileResource(name):
    """Return a path to the givem resource/template in the egg.
    """
    req = Requirement.parse('silva.export.opendocument')
    tp = 'silva/export/opendocument/templates/%s' % name
    return resource_filename(req, tp)


class ODFDocument(object):
    """Create an ODF Document from a template, let add ressource
    inside of it.
    """

    def __init__(self, template_name):
       template = open(fileResource(template_name), 'r')
       self.doc = StringIO()
       self.doc.write(template.read())
       self.doc.seek(0)

    def add(self, name, content):
        archive = ZipFile(self.doc, 'a')
        archive.writestr(name, content)
        archive.close()
        self.doc.seek(0)

    def download(self):
        return self.doc.getvalue()

class OpenDocumentExportAdapter(adapter.Adapter):
    """Adapter to export Silva Object to OpenDocument
    """
    
    implements(interfaces.IContentExporter)
    adapts(silva_interfaces.ISilvaObject)
    
    security = ClassSecurityInfo()

    name = "Open Document"
    extension = "odt"


    def _getXSLT(self):
        stream = open(fileResource('silva2odt.xslt'), 'r')
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
        export_root = xmlexport.SilvaExportRoot(self.context)
        xml_export = exporter.exportToString(export_root, settings, info)
        
        # now transform the XML
        xml_export = ElementTree(XML(xml_export))
        style_content = XSLT(self._getXSLT())

        content = style_content.apply(xml_export)
        document = ODFDocument('odt_template.zip')
        document.add('content.xml', tostring(content))
        return document.download()


Globals.InitializeClass(OpenDocumentExportAdapter)
