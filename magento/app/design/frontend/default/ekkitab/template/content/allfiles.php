<?php 

	function getArticles() {
		$articleXMLFile=Mage::getDesign()->getTemplateFilename("content/articlesindex.xml");
		
		if ( !file_exists($articleXMLFile) && !is_file($articleXMLFile) ) {
			return null;
		}
        $xml = simplexml_load_file($articleXMLFile);
        if (! $xml instanceof SimpleXmlElement) {
            return(null);
        }

		$articles = array();
        $filearticles = $xml->children();

        foreach($filearticles as $filearticle) {
            $article = array();
            $article['title'] = (string)$filearticle['title'];
            $article['image'] = (string)$filearticle['image'];
            $article['url']   = (string)$filearticle['url'];
            $article['description'] = trim($filearticle);
            $articles[] = $article;
        }

		return $articles;
	}
?>
