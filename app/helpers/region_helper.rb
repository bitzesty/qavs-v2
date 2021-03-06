module RegionHelper
  COUNTY_REGION_MAPPINGS = {
    "Bedfordshire": "England",
    "Berkshire": "England",
    "Bristol": "England",
    "Buckinghamshire": "England",
    "Cambridgeshire": "England",
    "Cheshire": "England",
    "Cornwall": "England",
    "County Durham": "England",
    "Cumbria": "England",
    "Derbyshire": "England",
    "Devon": "England",
    "Dorset": "England",
    "East Riding of Yorkshire": "England",
    "East Sussex": "England",
    "Essex": "England",
    "Gloucestershire": "England",
    "Greater London": "England",
    "Greater Manchester": "England",
    "Guernsey": "England",
    "Hampshire": "England",
    "Herefordshire": "England",
    "Hertfordshire": "England",
    "Isle of Man": "England",
    "Isle of Wight": "England",
    "Jersey": "England",
    "Kent": "England",
    "Lancashire": "England",
    "Leicestershire": "England",
    "Lincolnshire": "England",
    "Merseyside": "England",
    "Norfolk": "England",
    "North Yorkshire": "England",
    "Northamptonshire": "England",
    "Northumberland": "England",
    "Nottinghamshire": "England",
    "Oxfordshire": "England",
    "Rutland": "England",
    "Shropshire": "England",
    "Somerset": "England",
    "South Yorkshire": "England",
    "Staffordshire": "England",
    "Suffolk": "England",
    "Surrey": "England",
    "Tyne and Wear": "England",
    "Warwickshire": "England",
    "West Midlands": "England",
    "West Sussex": "England",
    "West Yorkshire": "England",
    "Wiltshire": "England",
    "Worcestershire": "England",
    "County Antrim": "Northern Ireland",
    "County Armagh": "Northern Ireland",
    "County Down": "Northern Ireland",
    "County Fermanagh": "Northern Ireland",
    "County Londonderry": "Northern Ireland",
    "County Tyrone": "Northern Ireland",
    "Aberdeenshire": "Scotland",
    "Angus": "Scotland",
    "Argyll and Bute": "Scotland",
    "Ayrshire": "Scotland",
    "Clackmannanshire": "Scotland",
    "Dumfries and Galloway": "Scotland",
    "Dunbartonshire": "Scotland",
    "Dundee": "Scotland",
    "East Lothian": "Scotland",
    "Edinburgh": "Scotland",
    "Falkirk": "Scotland",
    "Fife": "Scotland",
    "Glasgow": "Scotland",
    "Highland": "Scotland",
    "Inverclyde": "Scotland",
    "Lanarkshire": "Scotland",
    "Midlothian": "Scotland",
    "Moray": "Scotland",
    "Orkney": "Scotland",
    "Perth and Kinross": "Scotland",
    "Renfrewshire": "Scotland",
    "Scottish Borders": "Scotland",
    "Shetland Isles": "Scotland",
    "Stirlingshire": "Scotland",
    "West Lothian": "Scotland",
    "Western Isles": "Scotland",
    "Anglesey/Sir Fon": "Wales",
    "Blaenau Gwent": "Wales",
    "Bridgend": "Wales",
    "Caerphilly": "Wales",
    "Cardiff": "Wales",
    "Carmarthenshire": "Wales",
    "Ceredigion": "Wales",
    "Conwy": "Wales",
    "Denbighshire": "Wales",
    "Flintshire": "Wales",
    "Glamorgan": "Wales",
    "Gwynedd": "Wales",
    "Merthyr Tydfil": "Wales",
    "Monmouthshire": "Wales",
    "Neath Port Talbot": "Wales",
    "Newport": "Wales",
    "Pembrokeshire": "Wales",
    "Powys": "Wales",
    "Rhondda Cynon Taff": "Wales",
    "Swansea": "Wales",
    "Torfaen": "Wales",
    "Wrexham": "Wales"
  }

  def counties
    COUNTY_REGION_MAPPINGS.keys.sort
  end

  def regions
    COUNTY_REGION_MAPPINGS.values.sort
  end

  def lookup_region_for_county(county)
    COUNTY_REGION_MAPPINGS[county]
  end
end
