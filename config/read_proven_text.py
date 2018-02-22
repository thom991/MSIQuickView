## Author: thom991
import glob
import numpy
import json
import os
import pdb
from elasticsearch import Elasticsearch
import ConfigParser
from datetime import datetime

def cluster_health(es_ip):
    es = Elasticsearch([es_ip])
    es.cluster.health(wait_for_status='yellow', request_timeout=1)

def delete_index(es_ip):
    es = Elasticsearch([es_ip])
    es.indices.delete(index='multi-modal', ignore=[400, 404])
    print 'Deleted Index from ES'

def create_index(es_ip):
    es = Elasticsearch([es_ip])
    es.indices.create(index='multi-modal', ignore=400)

def create_type(es_ip ,stream_name):
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
                       "type": "date", "index": "not_analyzed", "format": "MM/DD/YYYY"
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
                       "type": "integer", "index": "not_analyzed"
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
    es.indices.put_mapping(index='multi-modal', doc_type=stream_name, body=body1)


def json_to_ES(es_ip, path):
    index_name = 'nous-las'
    ds_type = 'new_tech'
    path = path + '*.json'
    listing = glob.glob(path)
    file = [os.path.basename(x) for x in glob.glob(path)]
    len_of_listing = len(listing)
    for x in range(len_of_listing):
        with open(listing[x], 'r') as json_file:
            json_data = json.load(json_file)
            question_type = []
            question_pattern = []
            response = []
            question_type.append(json_data['type'])
            question_pattern.append(json_data['pattern'])
            len_question_pattern = len(question_pattern[0])
            id_name = question_type[0] + '_' + '_'.join(question_pattern[0])
            print id_name
            response.append(json_data['response'])
            doc={
                'pattern': question_pattern,
                'type': question_type,
                'response': response
            }
            es = Elasticsearch([es_ip])
            res = es.index(index=index_name, doc_type=ds_type, id=id_name, body=doc)

def txt_to_ES(es_ip, path):
    index_name = 'multi-modal'
    ds_type = 'data'
    lines = open('messages.txt').read().splitlines()
    len_of_lines = len(lines)
    for x in range(len_of_lines):
        print x
##        pdb.set_trace()
        es = Elasticsearch([es_ip])
        line = unicode(lines[x], errors='ignore')
        jsonLine = json.loads(line)
        doc = {
            'Domain': str(jsonLine['hasProvenance']['uniqueID']),
            'Scientist Name': str(jsonLine['hasProvenance']['scientistName']),
            'Date Acquired': datetime.strptime(jsonLine['hasProvenance']['date'], '%m/%d/%Y').strftime('%m/%d/%Y'),
            'Notes': str(jsonLine['hasProvenance']['notes']),
            'Dataset Name': str(jsonLine['hasProvenance']['datasetName']),
            'Folder Location': str(jsonLine['hasProvenance']['folderLocation']),
            '# Raw Files': int(jsonLine['hasProvenance']['numRawFiles']),
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
        }
        res = es.index(index=index_name, doc_type=ds_type, id=x, body=doc)
        
def main():
    config = ConfigParser.ConfigParser()
    config.readfp(open(r'config.ini'))
    es_ip = config.get('Elasticsearch', 'ip-address')
    #delete_index(es_ip)
    create_index(es_ip)
    create_type(es_ip ,'data')
    access_path = config.get('Data', 'access')
    es = Elasticsearch([es_ip])
    txt_to_ES(es_ip, access_path)
    print 'Enteries into ES Completed'

if __name__ == '__main__':
    main()


