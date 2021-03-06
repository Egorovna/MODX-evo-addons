<?php
/*
 * Рефакторинг сниппета от  http://e-kao.ru/multilingual-2 by Alexander Sharapov
 *
 * lngChange
 * Сниппет вывода иконок переключения языка
 *
 * Вызывайте так: [!lngChange? &langs=`префикс_языка,id_документа_modx;префикс_языка_2,id_документа_modx_2`!]
 * Пример: [!lngChange? &langs=`ru,4;en,5`!]
 */

$pagetitle = (isset($pagetitle)) ? $pagetitle : null;
$current = (isset($current)) ? $current : null;
$langsarr = explode(';', $langs);

foreach ($langsarr as $key => $value) {
        $langvalue = explode(',', $value);
        $langId[$langvalue[0]] = $langvalue[1];
}

$baseurl=$modx->config["base_url"];

if ($modx->documentObject['parent']=='0') {
        $lang=0;
} else {
        $lang=$modx->documentIdentifier;
        do {
                foreach ($modx->documentMap as $mapEntry) {
                        $parentId= array_search($lang, $mapEntry);
                        if ($parentId) break;
                }
                if ($parentId) $lang=$parentId;
        } while ($parentId);
}

function BaseReplace ($baseurl, $url) {
global $modx;
$url = str_replace(
$modx->config['friendly_url_suffix'], "", $url);
if ($baseurl == "/") return substr ($url, 1); else return str_replace ($baseurl, "", $url);
}
foreach ($langId as $key => $value) {
        if ($value == $lang) {
                $lang_name=$key;
        }
}
$output='<div class="lng-change">';
if ($current) {
        $output.='<div class="current-lang';
        foreach ($langId as $key2 => $value2) {
                if ($key2 == $lang_name) {
                        $output.=' '.$key2.'">';
                        if ( !$pagetitle ) {
                                $output .= $key2;
                        } else {
                                $title = $modx->getDocument($value2);
                                $output .= $title['pagetitle'];
                        }
                }
        }
        $output.='</div>';
}

$output.='<ul class="other-langs">';
foreach ($langId as $key2 => $value2) {
        if ($key2<>$lang_name) {
                $output.='<li><a href="';
                $url = str_replace ("/$lang_name/", "/$key2/", $modx->makeURL($modx->documentIdentifier));
                        if (array_key_exists(BaseReplace ($baseurl,$url), $modx->documentListing))
                                $output.=$url;
                        else
                                $output.=$modx->makeURL($value2);
                $output.='" class="'.$key2.'">';
                if ( !$pagetitle ) {
                        $output .= $key2;
                } else {
                        $title = $modx->getDocument($value2);
                        $output .= $title['pagetitle'];
                }

                $output .= '</a></li>';
        }
}
$output.='</ul></div>';

return $output;
?>