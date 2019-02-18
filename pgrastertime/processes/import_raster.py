# -*- coding: utf-8 -*-

## from pgrastertime.data.sqla import DBSession
## from pgrastertime import CONFIG
from pgrastertime.readers import RasterReader
from pgrastertime.processes import LoadRaster
from pgrastertime import CONFIG
import subprocess
import sys, os

class XMLRastersObject:

    def __init__(self, xml_filename,tablename,force):
        self.xml_filename = xml_filename
        self.tablename = tablename
        self.force = force

    def insertXML(self, xml_filename):
    
        # TODO: should use SQLAlchemy
        pg_host = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[1].split(':')[0]
        pg_port = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[1].split(':')[1]
        pg_dbname = CONFIG['app:main'].get('sqlalchemy.url').split('/')[3]
        pg_pw = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[0].split(':')[1]
        pg_user = CONFIG['app:main'].get('sqlalchemy.url').split('/')[2].split('@')[0].split(':')[0]
        
        # this bash file create ins.sql to run
        cmd = "sh ./xml.sh " + xml_filename
        if subprocess.call(cmd, shell=True) != 0:
           print("Fail to convert xml to sql...")
           return False
        
        cmd = "PGPASSWORD=" + pg_pw + " psql -U " + pg_user + " -d " + pg_dbname+ " -f ins.sql"
        if subprocess.call(cmd, shell=True) != 0:
             print("Fail to insert sql in database...")
             return False
        os.remove("ins.sql")      
        return True
         
    def importRasters(self):
        
        # if not a DFO file type, exit!
        if (self.xml_filename.find(".object.xml")== -1):
            print("Not standard XML file")
            return False
    
        ## we need to find ALL raster type file (4) referenced by te XML metadata file
        raster_prefix = self.xml_filename.replace(".object.xml", "")
    
        if (os.path.isfile(raster_prefix + "_depth.tiff") and
            os.path.isfile(raster_prefix + "_mean.tiff") and
            os.path.isfile(raster_prefix + "_stddev.tiff") and
            os.path.isfile(raster_prefix + "_density.tiff")):
        
            print("All raster finded! Importing rasters of " + self.xml_filename)
        
            # It's a load Metadata in database
            if not (self.insertXML(self.xml_filename)):
                print("Fail to insert XML metadata in database")
                return False
        
            ## Import all those raster in database
            reader = RasterReader(raster_prefix + '_depth.tiff',self.tablename,self.force)
            LoadRaster(reader).run()
            reader = RasterReader(raster_prefix + '_mean.tiff',self.tablename,self.force)
            LoadRaster(reader).run()
            reader = RasterReader(raster_prefix + '_stddev.tiff',self.tablename,self.force)
            LoadRaster(reader).run()
            reader = RasterReader(raster_prefix + '_density.tiff',self.tablename,self.force)
            LoadRaster(reader).run()

            return True
        
        else:
            print("ERROR source file missing for " + xml_objfile )
            return False
