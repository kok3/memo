//
//  GiantVoice.mm
//  GCloudSDK
//
//  Created by tl on 16/6/2.
//  Copyright © 2016年 Giant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVoice.h"
#import "GiantVoice.h"
extern "C"
{	
    static GVoice *_gVoice = nil;
    static bool _isRecordListener = false;
    static RecordCallBackListsener _recordListener;
    static bool _isUploadListener = false;
    static UploadCallBackListener _uploadListener;
    static bool _isDownloadListener = false;
    static DownloadCallBackListener _downloadListener;
    static bool _isPlayListener = false;
    static PlayCallBackListener _playListener;
    static bool _isVoice2WordListener = false;
    static VoiceToWordCallBackListener _voice2wordListener;
    static float timeMax;
    static const char* _downloadUrl;
}
@interface GiantVoice()<GVoiceDelegate>
@end
@implementation GiantVoice

#pragma mark - GVoiceDelegate
//录音回调
-(void)onGVoiceRecorderStatus:(RecordStatusCode)status withVolume:(float)volume withRecordTime:(float)time withAmrFileDir:(NSString *)fileDir
{
    switch (status) {
        case RECORD_START://开始录音
            if (_isRecordListener) {
                _recordListener.onRecordStartCB();
            }
            break;
            
        case RECORD_NOT_PREPARED: //录音设备没准备好
            if (_isRecordListener) {
                NSString *preStr = @"录音设备没准备好";
                _recordListener.onRecordErrorCB([preStr cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        case RECORD_END: //录音结束
        {
            if (_isRecordListener) {
                _recordListener.onRecordStopCB(time,[fileDir cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            _downloadUrl = [fileDir cStringUsingEncoding:NSUTF8StringEncoding];
        }
            break;
            
        case RECORD_CANCEL: //录音取消
            if (_isRecordListener) {
                NSString *cancel  = @"录音取消";
                _recordListener.onRecordErrorCB([cancel cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        case  RECORD_TIMEUP: //录音时间到
            if (_isRecordListener) {
                _recordListener.onRecordTimeUpCB();
                [_gVoice stopRecord];
            }
            break;
            
        case RECORD_MIN_TIME://录音时间太短
            if (_isRecordListener) {
                NSString *minstr = @"录音时间太短";
                _recordListener.onRecordErrorCB([minstr cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        case RECORD_NO_PERMISSION://没打开录音权限
            if (_isRecordListener) {
                NSString *permissstr = @"没打开录音权限";
                _recordListener.onRecordErrorCB([permissstr cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        case RECORD_ING: //正在录音(为增加的音量回调)
            if (_isRecordListener) {
                volume = volume < 0.0001 ? 0.0 : volume;
                _recordListener.onRecordVolumeCB((double)volume);
                if (timeMax) {//当前录音距最大录音时间还剩多长时间
                    //停止录音时定时器会多出来0.1
                    float count = time-0.1;
                    if ((timeMax-count) >= 0.0 ) {
                        _recordListener.onRecordTimeRemainCB(timeMax-count);
                    }
                }
            }
            break;
            
        default:
            break;
    }
}

//上传
- (void)onGVoiceUploadStatus:(SendStatusCode)status withVoiceURL:(NSString *)voiceUrl withFileDir:(NSString *)fileDir
{
    switch (status) {
        case SEND_SUCCESS: //上传成功
            if (_isUploadListener) {
                _downloadUrl = [voiceUrl cStringUsingEncoding:NSUTF8StringEncoding];
                _uploadListener.onUploadSuccessCB([fileDir cStringUsingEncoding:NSUTF8StringEncoding],_downloadUrl);
            }
            break;
            
        case SEND_FAILED_NO_IP: //发送失败，没有语音服务器IP
            if (_isUploadListener) {
                NSString *failStr = @"没获取到语音服务器的地址";
                _uploadListener.onUploadFailedCB([fileDir cStringUsingEncoding:NSUTF8StringEncoding],[failStr cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        case SEND_FAILED_VERFY: //验证失败
            if (_isUploadListener) {
                NSString *failStr = @"验证失败";
                _uploadListener.onUploadFailedCB([fileDir cStringUsingEncoding:NSUTF8StringEncoding],[failStr cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        case SEND_FAILED_NO_NETWORK: //发送失败，网络不好
            if (_isUploadListener) {
                NSString *failStr = @"发送失败，网络不好";
                _uploadListener.onUploadFailedCB([fileDir cStringUsingEncoding:NSUTF8StringEncoding],[failStr cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        case SEND_FAILED_NO_FILE: //发送失败，没有录音文件
            if (_isUploadListener) {
                NSString *failStr = @"发送失败，没有录音文件";
                _uploadListener.onUploadFailedCB([fileDir cStringUsingEncoding:NSUTF8StringEncoding],[failStr cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        case SEND_FAILED_TIMEOUT: //上传超时
            if (_isUploadListener) {
                NSString *failStr = @"上传超时";
                _uploadListener.onUploadFailedCB([fileDir cStringUsingEncoding:NSUTF8StringEncoding],[failStr cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        case SEND_FAILED_UNKNOW_ERROR: //发送失败，未知错误
            if (_isUploadListener) {
                NSString *failStr = @"发送失败，未知错误";
                _uploadListener.onUploadFailedCB([fileDir cStringUsingEncoding:NSUTF8StringEncoding],[failStr cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        case SEND_FAILED: //上传失败
            if (_isUploadListener) {
                NSString *failStr = @"上传失败";
                _uploadListener.onUploadFailedCB([fileDir cStringUsingEncoding:NSUTF8StringEncoding],[failStr cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        case SEND_FAILED_CONNECT_TIMEOUT: //上传连接服务器超时
            if (_isUploadListener) {
                NSString *failStr = @"上传连接服务器超时";
                _uploadListener.onUploadFailedCB([fileDir cStringUsingEncoding:NSUTF8StringEncoding],[failStr cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        case SEND_SUCCESS_IP: //连接服务器成功
//            if (_isUploadListener) {
//                NSString *failStr = @"连接服务器成功";
//                _uploadListener.onUploadFailedCB([fileDir cStringUsingEncoding:NSUTF8StringEncoding],[failStr cStringUsingEncoding:NSUTF8StringEncoding]);
//            }
            break;
            
        case SEND_FAILED_TOO_MANY_CONN: //请求过于频繁
            if (_isUploadListener) {
                NSString *failStr = @"请求过于频繁";
                _uploadListener.onUploadFailedCB([fileDir cStringUsingEncoding:NSUTF8StringEncoding],[failStr cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        default:
            break;
    }
}

//播放
- (void)onGVoicePlayStatus:(PlayStatusCode)status
{
    switch (status) {
            
        case PLAY_START:
            if (_isPlayListener) {
                _playListener.onPlayStartCB();
            }
            break;
            
        case PLAY_FAILED:
            if (_isPlayListener) {
                NSString *play = @"播放失败";
                _playListener.onPlayErrorCB([play cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        case PLAY_NO_ID:
            if (_isPlayListener) {
                NSString *play = @"播放失败，没有传入AudioID";
                _playListener.onPlayErrorCB([play cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        case PLAY_NO_FILE:
            if (_isPlayListener) {
                NSString *play = @"播放失败，没有此ID的录音文件";
                _playListener.onPlayErrorCB([play cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        case PLAY_FINISH:
            if (_isPlayListener) {
                _playListener.onPlayCompletedCB();
            }
            break;
            
        case PLAY_STOP:
            if (_isPlayListener) {
                _playListener.onPlayStopCB();
            }
            break;
            
        case PLAY_PAUSE:
            if (_isPlayListener) {
                _playListener.onPlayPauseCB();
            }
            break;
            
        case PLAY_RESUME:
            if (_isPlayListener) {
                _playListener.onPlayResumeCB();
            }
            break;
            
        default:
            break;
    }
}

//下载
- (void)onGVoiceDownloadStatus:(DownloadStatusCode)status withVoiceDir:(NSString *)voiceDir withVoiceUrl:(NSString *)voiceUrl
{
    switch (status) {
        case DOWNLOAD_SUCCESS:
            if (_isDownloadListener) {
                _downloadListener.onDownloadSuccessCB([voiceUrl cStringUsingEncoding:NSUTF8StringEncoding],[voiceDir cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        case DOWNLOAD_FAILED:
            if (_isDownloadListener) {
                NSString *downloadVoice = [NSString stringWithFormat:@"%@下载失败",voiceUrl];
                if(_isDownloadListener)
                    _downloadListener.onDownloadFailedCB([voiceUrl cStringUsingEncoding:NSUTF8StringEncoding],[downloadVoice cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            break;
            
        default:
            break;
    }
}

//转文字
- (void)onGVoiceConvertVoice2WordStatus:(AudioToTextStatusCode)status withVoiceText:(NSString *)text withFile:(NSString *)file
{
    switch (status) {
        case AUDIOTOTEXT_SUCCESS:
        {
            if (_isVoice2WordListener) {
                _voice2wordListener.onConvertSuccessCB([file cStringUsingEncoding:NSUTF8StringEncoding],[text cStringUsingEncoding:NSUTF8StringEncoding]);
            }
        }
            break;
            
        case AUDIOTOTEXT_TEXT_NULL:
        {
            if (_isVoice2WordListener) {
                NSString *convert = @"没有说话或者讯飞转换失败导致识别没有结果";
                _voice2wordListener.onConvertFailedCB([file cStringUsingEncoding:NSUTF8StringEncoding],[convert cStringUsingEncoding:NSUTF8StringEncoding]);
            }
        }
            break;
            
        case AUDIOTOTEXT_FAIL:
        {
            if (_isVoice2WordListener) {
                NSString *convert = [NSString stringWithFormat:@"转文字错误原因"];
                _voice2wordListener.onConvertFailedCB([file cStringUsingEncoding:NSUTF8StringEncoding],[convert cStringUsingEncoding:NSUTF8StringEncoding]);
            }
        }
            break;
            
        case AUDIOTOTEXT_ID_NULL:
        {
            if (_isVoice2WordListener) {
                NSString *convert = @"语音地址为空";
                _voice2wordListener.onConvertFailedCB([file cStringUsingEncoding:NSUTF8StringEncoding],[convert cStringUsingEncoding:NSUTF8StringEncoding]);
            }
        }
            break;
            
        case AUDIOTOTEXT_VOICEFILE_NULL:
        {
            if (_isVoice2WordListener) {
                NSString *convert = @"本地没有语音文件";
                _voice2wordListener.onConvertFailedCB([file cStringUsingEncoding:NSUTF8StringEncoding],[convert cStringUsingEncoding:NSUTF8StringEncoding]);
            }
        }
            break;
            
        default:
            break;
    }
}

//删除
- (void)onGVoiceDeleteStatus:(DeleteStatusCode)status withVoiceName:(NSString *)voiceName
{
    switch (status) {
        case DELETE_SUCCESS:
            break;
            
        case DELETE_FAIL:
            break;
            
        case DELETE_ALL_SUCCESS:
            break;
            
        case DELETE_ALL_FAIL:
            break;
            
        default:
            break;
    }
}
@end

extern "C"
{
    GiantVoice *giantvoice;
    /**把char 转成 NSString*/
    static NSString* CreateNSString(const char* string)
    {
        if (string != NULL)
            return [NSString stringWithUTF8String:string];
        else
            return [NSString stringWithUTF8String:""];
    }
    
    /**初始化SDK，请求音频服务器IP地址*/
    bool GVoice_Initialize(bool isPreservation,int gid, int zid, long uid, char *clientSys, char *clientResVer)
    {
        _gVoice = [[GVoice alloc]initWithPreservation:isPreservation GameID:gid zoneID:zid userID:uid clientSys:CreateNSString(clientSys) clientResVer:CreateNSString(clientResVer)];
        giantvoice = [[GiantVoice alloc]init];
        [_gVoice setDelegate:giantvoice];
        return true;
    }

    bool GVoice_Destroy()
    {
        //if(_gVoice != nil)
            //[_gVoice release];

        return true;
    }
    
    /**按下录音按钮，开始录音*/
    bool GVoice_StartRecord(){
        if (_gVoice == nil) {
            return false;
        }
        return [_gVoice startRecord];
    }
    
    //录音状态回调
    void GVoice_SetRecorderListener(RecordCallBackListsener* listener)
    {
        _isRecordListener = (bool)listener;
        
        if(_isRecordListener)
        {
            _recordListener = *listener;
        }
    }
    
    
    /** 设置录音最大时长  maxtime 最大录音时间  最好控制在60s以内*/
    void GVoice_SetRecordMaxTime(float maxtime)
    {
        if (_gVoice == nil) {
            return;
        }
        timeMax = maxtime;
        [_gVoice setRecordMaxTime:maxtime];
    }
    
    /** 设置录音最短时长 mintime 最小录音时间  最好不要低于0.5s,小于0.5秒，录音机还没反应过来呢，容易产生录音无效*/
    void GVoice_SetRecordMinTime(float mintime)
    {
        if (_gVoice == nil) {
            return;
        }
        [_gVoice setRecordMinTime:mintime];
    }
    
    /** 结束录音 */
    bool GVoice_StopRecord()
    {
        if (_gVoice == nil) {
            return false;
        }
        return [_gVoice stopRecord];
    }
    
    /** 判断是否正在录音*/
    bool GVoice_isRecording()
    {
        if (_gVoice == nil) {
            return false;
        }
        return [_gVoice isRecording];
    }
    
    /**取消发送，如果正在录音，先停止录音*/
    void GVoice_CancelRecording()
    {
        if (_gVoice == nil) {
            return;
        }
        [_gVoice cancelRecord];
    }
    
    /** 播放录音*/
    int GVoice_PlayVoice(const char *voiceUrl)
    {
        if (_gVoice == nil) {
            return 0;
        }
        return  [_gVoice playVoice:CreateNSString(voiceUrl)];
    }
    
    /** 播放回调 */
    void GVoice_SetPlayerListener(PlayCallBackListener* listener)
    {
        _isPlayListener = (bool)listener;
        if (_isPlayListener) {
            _playListener = *listener;
        }
    }
    
    /** 停止播放 */
    void GVoice_StopVoice()
    {
        if (_gVoice == nil) {
            return;
        }
        if (_isPlayListener) {
            _playListener.onPlayStopCB();
        }
        [_gVoice stopVoice];
    }

    /** 当前播放位置*/
    int GVoice_GetCurrentPlayPosition()
    {
        if (_gVoice == nil) {
            return -1;
        }

        if([_gVoice isPlaying])
            return [_gVoice getCurrentPlayPosition];

        return -1;
    }
    
    /** 判断播放是否暂停 */
    bool GVoice_IsVoicePause()
    {
        if (_gVoice == nil) {
            return false;
        }
        return [_gVoice isVoicePause];
    }
    
    /**清空本地所有缓存的音频文件*/
    bool GVoice_ClearAllAudioFile()
    {
        bool ret;
        if (_gVoice != nil&&[_gVoice clearAllAudioFile])
        {
            ret = true;
        }
        return  ret;
    }
    
    /**初始化转文字模块(全局初始化一次即可启动转文字功能模块)*/
    void GVoice_SetVoice2Word(const char *appid)
    {
        [GVoice enableVoiceToWord:CreateNSString(appid)];
    }
    
    /**根据id将录音文件转换为文字 */
    bool GVoice_ConvertVoiceToWords(const char *voiceUrl)
    {
        if (_gVoice == nil) {
            return false;
        }
        [_gVoice convertVoiceToWords:CreateNSString(voiceUrl)];
        return true;
    }
    
    /** 转文字回调 */
    void GVoice_SetConverterListener(VoiceToWordCallBackListener* listener)
    {
        _isVoice2WordListener = (bool)listener;
        if (_isVoice2WordListener) {
            _voice2wordListener = *listener;
        }
    }
      
    /**根据声音ID检查录音文件是否存在*/
    bool GVoice_IsVoiceFileExist(const char*voiceUrl)
    {
        if (_gVoice == nil) {
            return false;
        }
        return [_gVoice isVoiceFileExist:CreateNSString(voiceUrl)];
    }
	
	/**发送录音文件到服务器*/
    bool GVoice_UploadFile(const char *fileDir)
    {
        if (_gVoice == nil) {
            return  false;
        }
        [_gVoice uploadFileDir:CreateNSString(fileDir)];
        return true;
    }
    
    /** 上传回调 */
    void GVoice_SetUploadListener(UploadCallBackListener* listener)
    {
        _isUploadListener = (bool)listener;
        if (_isUploadListener) {
            _uploadListener = *listener;
        }
    }
    
    /**根据声音audioID下载录音文件*/
    bool GVoice_DownloadFile(const char* voiceUrl)
    {
        if (_gVoice == nil) {
            return false;
        }
        [_gVoice downloadFile:CreateNSString(voiceUrl)];
        return true;
    }
    
    /** 下载回调 */
    void GVoice_SetDownloadListener(DownloadCallBackListener *listener)
    {
        _isDownloadListener = (bool)listener;
        if(_isDownloadListener){
            _downloadListener = *listener;
        }
    }
    
    /** 添加播放语音音量 取值范围：0-1 */
    void GVoice_SetPlayerVolume(float volume)
    {
        if (_gVoice == nil) {
            return;
        }
        [_gVoice setPlayerVolume:volume];
    }
    
    /** 暂停播放 */
    void GVoice_PauseVoice()
    {
        if (_gVoice == nil) {
            return;
        }
        if (_isPlayListener) {
            _playListener.onPlayPauseCB();
        }
        [_gVoice pauseVoice];
    }
    
    /** 继续播放 */
    void GVoice_ResumeVoice()
    {
        if (_gVoice == nil) {
            return;
        }
        if (_isPlayListener) {
            _playListener.onPlayResumeCB();
        }
        [_gVoice resumeVoice];
    }
    
    /** 判断当前是否在正在播放 */
    bool GVoice_IsVoicePlaying()
    {
        return [_gVoice isPlaying];
    }
    
    /** 计算缓存文件的大小 单位：M */
    float GVoice_GetVoiceCacheSize()
    {
        if (_gVoice == nil) {
            return false;
        }
        return [_gVoice getVoiceCacheSize];
    }
    
    /** Log 输出开关 (默认开启)YES:显示；NO:不显示 */
    void GVoice_SetLogDebug(bool flag)
    {
        [GVoice setLogDebug:flag];
    }

    /**各游戏获取自己的IP*/
    void GVoice_SwitchServer(bool isPreservation,int gid, int zid, long uid, char *clientSys,char *clientResVer)
    {
        if (_gVoice == nil) {
            return;
        }
        [_gVoice switchServerWithPreservation:isPreservation GameID:gid zoneID:zid userID:uid clientSys:CreateNSString(clientSys) clientResVer:CreateNSString(clientResVer)];
    }
    
    /**启动一个线程去判断录音文件夹的大小是否大于10M，大于10M的话，其他删除，只保留5M
     */
    void GVoice_ClearOldAudioFiles()
    {
        if (_gVoice == nil) {
            return;
        }
        [_gVoice clearOldAudioFiles];
    }
    
    /** 设置语言类型 */
    void GVoice_SetVoiceLanguage(char *language)
    {
        [GVoice setVoice2WordLanguage:CreateNSString(language)];
    }
    
    /** 删除GCloud下的所有文件 */
    void GVoice_DeleteAllGCloudFile()
    {
        if (_gVoice == nil) {
            return;
        }
        [_gVoice deleteAllGCloudFile];
    }
    
    /**
     *  判断GCloud下的文件是否存在
     *  file : 文件名、本地路径、URL
     */
    bool GVoice_IsGCloudFileExist(const char* file)
    {
        if (_gVoice == nil) {
            return false;
        }
        return [_gVoice isGCloudFileExist:CreateNSString(file)];
    }
    
    /**
     * 删除GCloud下对应的单个文件
     * file : 文件名、本地路径、URL
     */
    bool GVoice_DeleteGCloudFile(const char* file)
    {
        if (_gVoice == nil) {
            return false;
        }
        return [_gVoice deleteGCloudFile:CreateNSString(file)];
    }
    
    /** 检测文件是否存在 */
    bool GVoice_IsFileExist(const char* filePath)
    {
        if (_gVoice == nil) {
            return false;
        }
        return [_gVoice isFileExist:CreateNSString(filePath)];
    }
    
    /** 删除文件*/
    bool GVoice_DeleteFile(const char* filePath)
    {
        if (_gVoice == nil) {
            return false;
        }
        return [_gVoice deleteFile:CreateNSString(filePath)];
    }
    
    
    
    
}

