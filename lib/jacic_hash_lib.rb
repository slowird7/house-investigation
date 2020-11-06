require 'ffi'

# こちらは使わないでください
module JACICHashLib
  extend FFI::Library
  ffi_lib Rails.root.join("JACIC", "JACIC.so") # 本番環境用
#  ffi_lib "/usr/local/lib/JACIC_HashLib/libJACIC_Hash.so" # 開発環境用  
  # int WINAPI JACIC_WriteHashValue(const char *sourceFile, const char *destFile);
  attach_function :JACIC_WriteHashValue, [:string, :string], :int
  # int WINAPI JACIC_CheckHashValue(const char *checkFile);
  attach_function :JACIC_CheckHashValue, [:string], :int
end

# こちらを使ってください
module JACICHash
  module_function
  
  # JPEGファイルのハッシュ値を計算して書き込む
  # @param [String] srcFilePath 入力ファイルパス
  # @param [String] dstFilePath 出力ファイルパス
  # @return [int]  JW_SUCCESS                            0 : 正常終了
  # @return [int]  JW_ERROR_INCORRECT_PARAMETER       -101 : 不正な引数が指定された場合
  # @return [int]  JW_ERROR_SAME_FILE_PATH            -102 : 読込元と出力先の画像ファイルパスが同じ
  # @return [int]  JW_ERROR_READ_FILE_NOT_EXISTS      -201 : 読込元画像ファイルが存在しない
  # @return [int]  JW_ERROR_WRITE_FILE_ALREADY_EXISTS -202 : 出力先画像ファイルが既に存在する
  # @return [int]  JW_ERROR_READ_FILE_OPEN_FAILED     -203 : ファイルオープン失敗
  # @return [int]  JW_ERROR_READ_FILE_SIZE_ZERO       -204 : 読み込んだファイルサイズがゼロ
  # @return [int]  JW_ERROR_WRITE_FILE_FAILED         -205 : ファイル書き込み失敗
  # @return [int]  JW_ERROR_FILE_CLOSE_FAILED         -206 : ファイルのクローズに失敗
  # @return [int]  JW_ERROR_INCORRECT_EXIF_FORMAT     -301 : Exif フォーマットが不正
  # @return [int]  JW_ERROR_APP5_ALREADY_EXISTS       -302 : APP5 セグメントが既に存在する
  # @return [int]  JW_ERROR_OTHER                     -900 : その他のエラー
  def writeHash(srcFilePath, dstFilePath)
      return JACICHashLib.JACIC_WriteHashValue(srcFilePath, dstFilePath)
  end
  
  # JPEGファイルのハッシュ値を検証する
  # @param [String] filePath ファイルパス
  # @return [int] JC_OK                                 1 : ハッシュ値が一致した
  # @return [int] JC_NG                                 0 : ハッシュ値（画像、撮影日時の両方）が一致しない
  # @return [int] JC_NG_IMAGE                          -1 : ハッシュ値（画像）が一致しない
  # @return [int] JC_NG_DATE                           -2 : ハッシュ値（撮影日時）が一致しない
  # @return [int] JC_ERROR_INCORRECT_PARAMETER       -101 : 不正な引数が指定された場合
  # @return [int] JC_ERROR_READ_FILE_NOT_EXISTS      -201 : 読込元画像ファイルが存在しない
  # @return [int] JC_ERROR_READ_FILE_OPEN_FAILED     -203 : ファイルオープン失敗
  # @return [int] JC_ERROR_READ_FILE_SIZE_ZERO       -204 : 読み込んだファイルサイズがゼロ
  # @return [int] JC_ERROR_FILE_CLOSE_FAILED         -206 : ファイルのクローズに失敗
  # @return [int] JC_ERROR_INCORRECT_EXIF_FORMAT     -301 : Exif フォーマットが不正
  # @return [int] JC_ERROR_APP5_NOT_EXISTS           -303 : APP5 領域が見つからない
  # @return [int] JC_ERROR_INCORRECT_APP5_FORMAT     -304 : APP5 領域の記述形式が異なる
  # @return [int] JC_ERROR_HASH_NOT_EXISTS           -305 : ハッシュ値が設定されていない
  # @return [int] JC_ERROR_OTHER                     -900 : その他のエラー
  def checkHash(filePath)
      return JACICHashLib.JACIC_CheckHashValue(filePath)
  end
end
