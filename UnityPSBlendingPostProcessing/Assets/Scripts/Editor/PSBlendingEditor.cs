using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace Dawn.PostProcessing
{
    [CustomEditor(typeof(PSBlending))]
    public class PSBlendingEditor : Editor
    {
        private PSBlending psBlending { get { return target as PSBlending; } }

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();
            EditorGUI.BeginChangeCheck();
            psBlending.Shader = (Shader)EditorGUILayout.ObjectField("Shader", psBlending.Shader, typeof(Shader), false);
            psBlending.BlendMode = (PSBlendMode)EditorGUILayout.EnumPopup("Blend Mode", psBlending.BlendMode);
            if (EditorGUI.EndChangeCheck())
            {
                if(psBlending.material)
                {
                    psBlending.UpdateProperties();
                    psBlending.UpdateKeywords();
                    EditorUtility.SetDirty(target);
                }
                else
                {
                    Debug.LogWarning("You haven't assigned a shader yet");
                }
            }
            psBlending.Texture = (Texture)EditorGUILayout.ObjectField("Texture", psBlending.Texture, typeof(Texture), false);
        }
    }

}
