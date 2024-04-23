data "archive_file" "function" {
  type        = "zip"
  excludes    = split("\n", file("${path.module}/fastapi-on-azure-functions/.funcignore"))
  source_dir  = "${path.module}/fastapi-on-azure-functions"
  output_path = "${path.module}/example.zip"
}

data "archive_file" "rag_video_tagging" {
  type        = "zip"
  excludes    = split("\n", file("${path.module}/rag-video-tagging/code/durablefunction/.funcignore"))
  source_dir  = "${path.module}/rag-video-tagging/code/durablefunction"
  output_path = "${path.module}/rag.zip"
}

