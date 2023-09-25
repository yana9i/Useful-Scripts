mkdir out
Get-ChildItem  -Filter *.xml | ForEach-Object -Process {
    [xml]$xml = Get-Content $_
    $jpgPwd = "$($_.DirectoryName)\$($_.BaseName).jpg"
    Write-Output $jpgPwd
    for ($i = 0; $i -lt $xml.annotation.object.Length; $i++) {
        $obj = $xml.annotation.object[$i]
        if (-Not(Test-Path "./out/$($obj.name)")) {
            mkdir "./out/$($obj.name)"
        }
        $targetWidth = $obj.bndbox.xmax - $obj.bndbox.xmin
        $targetHeight = $obj.bndbox.ymax - $obj.bndbox.ymin
        $ffmpegParameter = "crop=$($targetWidth):$($targetHeight):$($obj.bndbox.xmin):$($obj.bndbox.ymin)"
        ffmpeg -i $jpgPwd -filter:v $ffmpegParameter "./out/$($obj.name)/$($_.BaseName)_$($i).jpg"
    }
}