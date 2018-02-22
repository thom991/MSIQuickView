## Author: thom991
## ===============================================================================================================================================================================
## To call from cmd
## python
## >>> import JSON_to_ES
## >>> JSON_to_ES.main({"dataset_name": "nic1", "dataset-modality": "nanodesi", "process": "test workflow", "elapsed": "15.4908", "remaining": "18.8907", "status": "Not Working", "elasticsearchIP": "http://localhost:9200/", "indexName": "lungmap", "data_access": "C:/Users/thom991/Documents/Work/Projects/AIM/Nous LAS/testData/"}, 'provenance')
## ===============================================================================================================================================================================
import glob
import numpy
import json
import os
import pdb
from elasticsearch import Elasticsearch
import ConfigParser

def cluster_health(es_ip): #check cluster health
    es = Elasticsearch([es_ip])
    es.cluster.health(wait_for_status='yellow', request_timeout=1)

def delete_index(es_ip, index_name): #delete an index
    es = Elasticsearch([es_ip])
    es.indices.delete(index=index_name, ignore=[400, 404])

def create_index(es_ip, index_name): #create an index in ES
    es = Elasticsearch([es_ip])
    body1 = {
      "index.mapping.total_fields.limit": 60000
    }
    es.indices.create(index=index_name, ignore=400, body=body1)

def create_type(es_ip ,stream_name, index_name): #create a doc_type for an index
    # This is where we define the mapping. Not necessary, mapping is dynamically updated with partial updates including new fields
    body1 = {
	   stream_name: {
             "properties": {
                "process": {
                   "type": "string"
                },
                "time-elapsed": {
                   "type": "float"
                },
                "time-remaining": {
                   "type": "float"
                },
                "status": {
                   "type": "string"
                },
                "dataset-modality": {
                   "type": "string"
                }
             }
	   }
    }
    es = Elasticsearch([es_ip])
    es.indices.put_mapping(index=index_name, doc_type=stream_name, body=body1)

def create_provenance_type(es_ip ,stream_name):
    body1 = {
	   stream_name: {
                "properties": {
                    "Domain": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Scientist Name": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Date Acquired": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Notes": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Dataset Name": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Folder Location": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "# Raw Files": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Start Line #": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Aspect Ratio": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "m/z Range": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "m/z Plot Values": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "m/z Plot Values Threshold": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Normalize Data": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Apply Changes to All Images": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Save Settings": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Redo Image": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "m/z Excel File": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "m/z Excel File Sheet Name": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "m/z Excel File Rows [start, end]": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "PDF #": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Export Pixels to Excel": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Align Image": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Remove Lines": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Interpolated Data Values": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Scale Image Values": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Colormap": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Save Image": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "User Selected m/z list to save": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "dpi Value": {
                       "type": "string", "index": "not_analyzed"
                    },
                    "Include Axis with Image": {
                       "type": "string", "index": "not_analyzed"
                    }
                    
                }
	   }
    }
    es = Elasticsearch([es_ip])
    es.indices.put_mapping(index=index_name, doc_type=stream_name, body=body1)
    
def json_to_ES(es_ip, path, index_name, ss):
    index_name = index_name
    ds_type = ss["dataset-modality"]
    id_name = ss["dataset_name"]
    doc = {}
    for x in range(0, len(ss)):
        doc.update({ss.keys()[x]: ss.values()[x]})
    es = Elasticsearch([es_ip])
    try:
        res = es.update(index=index_name, doc_type=ds_type, id=id_name, body={"doc":doc})
    except:
        res = es.index(index=index_name, doc_type=ds_type, id=id_name, body={"doc":doc})

def provenance_txt_to_ES(es, index_name, domain, ss):
    ds_type = ss["dataset-modality"]
    id_name = ss["dataset_name"]
    lines = open(ss["text_file_location"]).read().splitlines()
    len_of_lines = len(lines)
    for x in range(len_of_lines):
        line = unicode(lines[x], errors='ignore')
        jsonLine = json.loads(line)
        doc = {'provenance' + str(x):{
            'Domain': str(jsonLine['hasProvenance']['uniqueID']),
            'Scientist Name': str(jsonLine['hasProvenance']['scientistName']),
            'Date Acquired': str(jsonLine['hasProvenance']['date']),
            'Notes': str(jsonLine['hasProvenance']['notes']),
            'Dataset Name': str(jsonLine['hasProvenance']['datasetName']),
            'Folder Location': str(jsonLine['hasProvenance']['folderLocation']),
            '# Raw Files': str(jsonLine['hasProvenance']['numRawFiles']),
            'Start Line #': str(jsonLine['hasProvenance']['rawStartNo']),
            'Aspect Ratio': str(jsonLine['hasProvenance']['aspectRatio']),
            'm/z Range': str(jsonLine['hasProvenance']['mzRange']),
            'm/z Plot Values': str(jsonLine['hasProvenance']['mzPlotVals']),
            'm/z Plot Values Threshold': str(jsonLine['hasProvenance']['mzPlotValsThresh']),
            'Normalize Data': str(jsonLine['hasProvenance']['normalizeData']),
            'Apply Changes to All Images': str(jsonLine['hasProvenance']['applyChangesToAllImages']),
            'Save Settings': str(jsonLine['hasProvenance']['saveSettings']),
            'Redo Image': str(jsonLine['hasProvenance']['redoImage']),
            'm/z Excel File': str(jsonLine['hasProvenance']['redoImageExcelfileName']),
            'm/z Excel File Sheet Name': str(jsonLine['hasProvenance']['redoImageExcelSheetName']),
            'm/z Excel File Rows [start, end]': str(jsonLine['hasProvenance']['redoImageExcelmzRows']),
            'PDF #': str(jsonLine['hasProvenance']['redoImagePDFno']),
            'Export Pixels to Excel': str(jsonLine['hasProvenance']['exportPixelsValsToExcel']),
            'Align Image': str(jsonLine['hasProvenance']['alignImage']),
            'Remove Lines': str(jsonLine['hasProvenance']['removeLines']),
            'Interpolated Data Values': str(jsonLine['hasProvenance']['interpolatedDataValues']),
            'Scale Image Values': str(jsonLine['hasProvenance']['scaleImageValues']),
            'Colormap': str(jsonLine['hasProvenance']['colorMap']),
            'Save Image': str(jsonLine['hasProvenance']['saveImage']),
            'User Selected m/z list to save': str(jsonLine['hasProvenance']['imageListToSave']),
            'dpi Value': str(jsonLine['hasProvenance']['dpiVal']),
            'Include Axis with Image': str(jsonLine['hasProvenance']['includeAxisImageSave'])
        }}
        try:
            res = es.update(index=index_name, doc_type=ds_type, id=id_name, body={"doc":doc})
        except:
            res = es.index(index=index_name, doc_type=ds_type, id=id_name, body={"doc":doc})
    
def main(ss, model):
    es_ip = ss["elasticsearchIP"]
    index_name = ss["indexName"]
    ds_type = ss["dataset-modality"]
    access_path = ss["data_access"]
    ##delete_index(es_ip, index_name)
    es = Elasticsearch([es_ip])
    if not es.indices.exists(index=index_name):  
        create_index(es_ip, index_name)
    if not es.indices.exists_type(index=index_name, doc_type=ds_type):           
        create_type(es_ip, ds_type, index_name)       
    ## If Provenance
    if(model == 'provenance'):
        provenance_txt_to_ES(es, index_name, ds_type, ss)
        print 'Enteries into ES Completed'
    else:
        json_to_ES(es_ip, access_path, index_name, ss)
    print 'Enteries into ES Completed'

if __name__ == '__main__':
    main()
