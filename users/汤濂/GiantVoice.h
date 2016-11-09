//
//  GiantVoice.h
//  GCloudSDK
//
//  Created by tl on 16/6/2.
//  Copyright © 2016年 Giant. All rights reserved.
//
#ifndef __VOICECHAT_WRAP_H__
#define __VOICECHAT_WRAP_H__

#import <Foundation/Foundation.h>
@interface GiantVoice : NSObject
@end
extern "C"
{
    /**GiantVoice
     * 录音回调
     * onRecordStartCB      : 录音开始回调
     * onRecordStopCB       : 录音停止时回调总共录音多少时间
     * onRecordErrorCB      : 录音错误时回调录音失败原因
     * onRecordTimeRemainCB : 录音时回调距最大录音时间还剩多少时间
     * onRecordTimeUpCB     : 录音超时回调超时描述
     * onRecordVolumeCB     : 录音时回调声音的振幅
     */
    struct RecordCallBackListsener
    {
        void (*onRecordStartCB)();
        void (*onRecordStopCB)(float,const char*);
        void (*onRecordErrorCB)(const char*);
        void (*onRecordTimeRemainCB)(float);
        void (*onRecordTimeUpCB)();
        void (*onRecordVolumeCB)(double);//声音振幅
        //void (*onRecordTimeCountCB)(double);
    };
    
    /**GiantVoice
     * 上传回调
     * onUploadSuccessCB : 上传成功后回调出文件的本地地址fileDir 和 文件URL
     * onUploadFailedCB  : 上传失败后回调出文件的本地地址fileDir 和 失败的原因描述
     */
    struct UploadCallBackListener
    {
        void (*onUploadSuccessCB)(const char *,const char *);
        void (*onUploadFailedCB)(const char *,const char *);
    };
    
    /**GiantVoice
     * 下载回调
     * onDownloadSuccessCB : 下载成功后回调文件URL地址 和 本地地址fileDir
     * onDownloadFailedCB  : 下载失败后回调文件URL地址 和 失败描述
     */
    struct DownloadCallBackListener
    {
        void (*onDownloadSuccessCB)(const char*,const char*);
        void (*onDownloadFailedCB)(const char*, const char *);
    };
    
    /**GiantVoice
     * 播放回调
     * onPlayErrorCB     : 播放错误回调播放失败描述
     * onPlayStartCB     : 开始播放回调
     * onPlayPauseCB     : 暂停播放回调
     * onPlayResumeCB    : 继续播放回调
     * onPlayStopCB      : 停止播放回调
     * onPlayCompletedCB : 播放完成回调
     */
    struct PlayCallBackListener
    {
        void (*onPlayErrorCB)(const char *);
        void (*onPlayStartCB)();
        void (*onPlayPauseCB)();
        void (*onPlayResumeCB)();
        void (*onPlayStopCB)();
        void (*onPlayCompletedCB)();
    };
    
    /**GiantVoice
     * 语音转文字回调
     * onConvertSuccessCB : 转文字成功后回调URL 和 转成的文字
     * onConvertFailedCB  : 转文字失败后回调URL 和 失败的描述
     */
    struct VoiceToWordCallBackListener
    {
        void (*onConvertSuccessCB)(const char *, const char *);
        void (*onConvertFailedCB)(const char*, const char *);
    };
    
   
    /**GiantVoice
     * 初始化SDK
     * gid          : 游戏id
     * zid          : 游戏区id
     * uid          : 用户id
     * clientSys    : 游戏的区分名，服务器定
     * clientResVer : 语音服务器区，默认写first，服务器定
     */
    extern bool GVoice_Initialize(int gid, int zid, long uid, char *clientSys, char *clientResVer);
    
    /** 按下录音按钮，开始录音 */
    extern bool GVoice_Destroy();

    /** 按下录音按钮，开始录音 */
    extern bool GVoice_StartRecord();
    
    /** 设置录音最大时长  maxtime 最大录音时间  最好控制在60s以内 */
    extern void GVoice_SetRecordMaxTime(float maxtime);
    
    /** 设置录音最短时长 mintime 最小录音时间  最好不要低于0.5s,小于0.5秒，录音机还没反应过来呢，容易产生录音无效 */
    extern void GVoice_SetRecordMinTime(float mintime);
    
    /** 结束录音 */
    extern bool GVoice_StopRecord();
    
    /** 判断是否正在录音 */
    extern bool GVoice_isRecording();
    
    /** 发送录音文件到服务器 */
    extern bool GVoice_UploadFile(const char *fileDir);
    
    /** 取消发送，如果正在录音，先停止录音 */
    extern void GVoice_CancelRecording();
    
    /** 播放录音 */
    extern int GVoice_PlayVoice(const char *voiceUrl);
    
    /** 停止播放 */
    extern void GVoice_StopVoice();

    /** 当前播放位置 */
    extern int GVoice_GetCurrentPlayPosition();
    
    /** 清空本地所有缓存的音频文件 */
    extern bool GVoice_ClearAllAudioFile();
    
    /** 初始化转文字模块(全局初始化一次即可启动转文字功能模块) */
    extern void GVoice_SetVoice2Word(const char *appid);
    
    /** 根据voiceUrl将录音文件转换为文字 */
    extern bool GVoice_ConvertVoiceToWords(const char *voiceUrl);
    
    
    /** 根据声音ID检查录音文件是否存在 */
    extern bool GVoice_IsVoiceFileExist(const char*voiceUrl);
    
    /** 根据声音voiceUrl下载录音文件 */
    extern bool GVoice_DownloadFile(const char* voiceUrl);
    
    /** 添加播放语音音量 取值范围：0-1 */
    extern void GVoice_SetPlayerVolume(float volume);
    
    /** 暂停播放 */
    extern void GVoice_PauseVoice();
    
    /** 继续播放 */
    extern void GVoice_ResumeVoice();
    
    /** 判断当前是否在正在播放 */
    extern bool GVoice_IsVoicePlaying();
    
    /** 判断播放是否暂停 */
    extern bool GVoice_IsVoicePause();
    
    /** 计算缓存文件的大小 单位：M */
    extern float GVoice_GetVoiceCacheSize();
    
    /** 启动一个线程去判断录音文件夹的大小是否大于10M，大于10M的话，其他删除，只保留5M */
    extern void GVoice_ClearOldAudioFiles();
    
    /** Log 输出开关 (默认开启)YES:显示；NO:不显示 */
    extern void GVoice_SetLogDebug(bool flag);

    /** 各游戏获取自己的IP */
    extern void GVoice_SwitchServer(int gid, int zid, long uid, char *clientSys,char *clientResVer);
    
    /** 设置语言类型 */
    extern void GVoice_SetVoiceLanguage(char *language);
    
    /** 播放回调 */
    extern void GVoice_SetPlayerListener(PlayCallBackListener* listener);
    
    /** 转文字回调 */
    extern void GVoice_SetConverterListener(VoiceToWordCallBackListener* listener);
    
    /** 录音回调 */
    extern void GVoice_SetRecorderListener(RecordCallBackListsener* listener);
    
    /** 上传回调 */
    extern void GVoice_SetUploadListener(UploadCallBackListener* listener);
    
    /** 下载回调 */
    extern void GVoice_SetDownloadListener(DownloadCallBackListener *listener);
    
    /** 删除GCloud下的所有文件 */
    extern void GVoice_DeleteAllGCloudFile();
    
    /**
     *  判断GCloud下的文件是否存在
     *  file : 文件名、本地路径、URL
     */
    extern bool GVoice_IsGCloudFileExist(const char* file);
    
    /**
     * 删除GCloud下对应的单个文件
     * file : 文件名、本地路径、URL
     */
    extern bool GVoice_DeleteGCloudFile(const char* file);
    
    /** 检测文件是否存在 */
    extern bool GVoice_IsFileExist(const char* filePath);
    
    /** 删除文件*/
    extern bool GVoice_DeleteFile(const char* filePath);
}

#endif

